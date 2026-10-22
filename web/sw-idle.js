let negotiating = false;
self.addEventListener('message', event => {
  if (event.data?.type !== 'ACTIVATE_WHEN_IDLE' || negotiating) return;
  negotiating = true;
  event.waitUntil((async () => {
    const scope = self.registration.scope;
    const windows = (await self.clients.matchAll({type: 'window', includeUncontrolled: true}))
      .filter(client => client.url.startsWith(scope));
    const approvals = await Promise.all(windows.map(client => new Promise(resolve => {
      const channel = new MessageChannel();
      const timer = setTimeout(() => { channel.port1.close(); resolve(false); }, 3000);
      channel.port1.onmessage = reply => {
        clearTimeout(timer);
        channel.port1.close();
        resolve(reply.data?.safe === true);
      };
      client.postMessage({type: 'CAN_ACTIVATE'}, [channel.port2]);
    })));
    if (windows.length && approvals.every(Boolean)) {
      await self.skipWaiting();
    } else {
      negotiating = false;
      windows.forEach(client => client.postMessage({type: 'UPDATE_DEFERRED'}));
    }
  })());
});
