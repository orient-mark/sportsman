/* Persistence is deliberately independent of the versioned application cache. */
(() => {
  'use strict';
  const databaseName = 'orientmark-sportsman';
  let databasePromise;
  let pendingWrites = 0;
  let pendingOperations = 0;
  let safeToUpdate = false;
  let registration;
  let activating = false;
  let reloadPending = false;
  let torchOn = false;
  let torchTrack;
  let statusTimer;

  function status(message, transient = false) {
    const element = document.getElementById('pwa-status');
    if (!element) return;
    clearTimeout(statusTimer);
    element.textContent = message;
    element.hidden = false;
    if (transient) statusTimer = setTimeout(() => { element.hidden = true; }, 6000);
  }

  function openDatabase() {
    if (!databasePromise) {
      databasePromise = new Promise((resolve, reject) => {
        const request = indexedDB.open(databaseName, 1);
        request.onupgradeneeded = () => {
          if (!request.result.objectStoreNames.contains('documents')) {
            request.result.createObjectStore('documents');
          }
        };
        request.onerror = () => reject(request.error);
        request.onblocked = () => status('Закройте другие окна OrientMark для открытия хранилища.');
        request.onsuccess = () => {
          const database = request.result;
          database.onversionchange = () => {
            database.close();
            databasePromise = undefined;
          };
          resolve(database);
        };
      }).catch(error => { databasePromise = undefined; throw error; });
    }
    return databasePromise;
  }

  async function transaction(mode, operation) {
    if (mode === 'readwrite') pendingWrites++;
    try {
      const database = await openDatabase();
      return await new Promise((resolve, reject) => {
        const tx = database.transaction('documents', mode);
        let value;
        tx.oncomplete = () => resolve(value);
        tx.onabort = tx.onerror = () => reject(tx.error || new Error('IndexedDB transaction failed'));
        try { operation(tx.objectStore('documents'), result => { value = result; }); }
        catch (error) { tx.abort(); reject(error); }
      });
    } finally {
      if (mode === 'readwrite') pendingWrites--;
      applyUpdateIfSafe();
    }
  }

  globalThis.sportsmanStorage = Object.freeze({
    read: key => transaction('readonly', (store, result) => {
      const request = store.get(key);
      request.onsuccess = () => result(request.result ?? '');
    }),
    write: (key, value) => transaction('readwrite', store => { store.put(value, key); }),
    remove: key => transaction('readwrite', store => { store.delete(key); }),
    append: (key, value) => transaction('readwrite', store => {
      const request = store.get(key);
      request.onsuccess = () => {
        try {
          const values = request.result ? JSON.parse(request.result) : [];
          values.push(JSON.parse(value));
          store.put(JSON.stringify(values), key);
        } catch (_) { store.transaction.abort(); }
      };
    })
  });

  function activeVideoTrack(root = document) {
    for (const video of root.querySelectorAll('video')) {
      const track = video.srcObject?.getVideoTracks?.().find(item => item.readyState === 'live');
      if (track) return track;
    }
    for (const element of root.querySelectorAll('*')) {
      if (element.shadowRoot) {
        const track = activeVideoTrack(element.shadowRoot);
        if (track) return track;
      }
    }
    return undefined;
  }

  function applyUpdateIfSafe() {
    if (!safeToUpdate || pendingWrites || pendingOperations || document.hidden || activeVideoTrack()) return;
    if (reloadPending) { location.reload(); return; }
    if (!registration?.waiting || activating) return;
    // Other tabs must also be idle. A waiting worker is safe to activate once
    // no other app window can still be recording or transferring a result.
    activating = true;
    registration.waiting.postMessage({type: 'ACTIVATE_WHEN_IDLE'});
  }

  globalThis.sportsmanPwa = Object.freeze({
    setSafeToUpdate(safe) { safeToUpdate = safe; applyUpdateIfSafe(); },
    beginOperation() { pendingOperations++; },
    endOperation() { pendingOperations--; applyUpdateIfSafe(); },
    torchAvailable() {
      const track = activeVideoTrack();
      if (!track) return false;
      const capabilities = track.getCapabilities?.() || {};
      return capabilities.torch === true || Array.isArray(capabilities.torch) && capabilities.torch.includes(true)
        || !!navigator.mediaDevices?.getSupportedConstraints?.().torch;
    },
    async toggleTorch() {
      const track = activeVideoTrack();
      if (!track) throw new Error('Camera is not running');
      if (track !== torchTrack) { torchTrack = track; torchOn = false; }
      const target = !torchOn;
      await track.applyConstraints({advanced: [{torch: target}]});
      torchOn = target;
      return target;
    }
  });

  async function persist() {
    try {
      if (navigator.storage?.persist) await navigator.storage.persist();
    } catch (_) { /* A denied persistence request does not erase the database. */ }
  }

  async function register() {
    if (!('serviceWorker' in navigator)) {
      status('Этот браузер не поддерживает автономную установку.');
      return;
    }
    try {
      // Reuse the installed registration when starting offline. Registering the
      // same script again can fail without a network, before listeners attach.
      const scope = new URL('./', document.baseURI).href;
      const installed = await navigator.serviceWorker.getRegistration(scope);
      registration = installed?.scope === scope ? installed
        : await navigator.serviceWorker.register('sw.js', {scope, updateViaCache: 'none'});
      const watch = worker => {
        if (!worker) return;
        worker.addEventListener('statechange', () => {
          if (worker.state === 'installed') {
            if (navigator.serviceWorker.controller) {
              status('Обновление загружено. Установится на главном экране.');
              applyUpdateIfSafe();
            } else { status('Приложение готово к работе без интернета.', true); }
          }
          if (worker.state === 'redundant') status('Не удалось подготовить автономную версию. Подключитесь к интернету и откройте приложение снова.');
        });
      };
      watch(registration.installing);
      registration.addEventListener('updatefound', () => watch(registration.installing));
      if (registration.waiting) applyUpdateIfSafe();
      else if (navigator.serviceWorker.controller) status('Автономная версия доступна.', true);
      navigator.serviceWorker.addEventListener('controllerchange', () => {
        if (activating || reloadPending) { reloadPending = true; applyUpdateIfSafe(); }
      });
      navigator.serviceWorker.addEventListener('message', event => {
        if (event.data?.type === 'CAN_ACTIVATE') {
          const safe = safeToUpdate && !pendingWrites && !pendingOperations && !activeVideoTrack();
          if (safe) {
            activating = true;
            let lock = document.getElementById('pwa-update-lock');
            if (!lock) {
              lock = document.createElement('div');
              lock.id = 'pwa-update-lock';
              lock.style.cssText = 'position:fixed;inset:0;z-index:2147483646;background:#ffffffb3;';
              document.body.append(lock);
            }
            status('Установка обновления…');
          }
          event.ports[0]?.postMessage({safe});
        }
        if (event.data?.type === 'UPDATE_DEFERRED') {
          activating = false;
          document.getElementById('pwa-update-lock')?.remove();
          status('Обновление ожидает завершения работы в других окнах.', true);
        }
      });
      await persist();
      checkUpdate();
    } catch (error) {
      console.error('PWA setup failed', error);
      status('Автономная версия пока не подготовлена. Проверьте интернет и откройте приложение снова.');
    }
  }

  function checkUpdate() {
    if (navigator.onLine) registration?.update().catch(() => {});
    applyUpdateIfSafe();
  }
  window.addEventListener('load', register);
  window.addEventListener('online', checkUpdate);
  document.addEventListener('visibilitychange', () => {
    if (!document.hidden) { checkUpdate(); persist(); }
  });
  setInterval(checkUpdate, 60_000);
})();
