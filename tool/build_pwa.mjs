import {spawnSync} from 'node:child_process';
import {copyFile, mkdir, readFile, rm, writeFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {createRequire} from 'node:module';
import {generateSW} from 'workbox-build';

const root = fileURLToPath(new URL('../', import.meta.url));
const require = createRequire(import.meta.url);
const baseHref = process.env.PWA_BASE_HREF || '/sportsman/';
if (baseHref !== '/' && !/^\/[a-zA-Z0-9/_-]*\/$/.test(baseHref)) throw new Error('PWA_BASE_HREF must be an absolute path ending with /');
const result = spawnSync(process.platform === 'win32' ? 'flutter.bat' : 'flutter', [
  'build', 'web', '--release', '--no-web-resources-cdn', '--base-href', baseHref,
], {cwd: root, stdio: 'inherit', shell: process.platform === 'win32'});
if (result.error) throw result.error;
if (result.status !== 0) process.exit(result.status || 1);

const output = path.join(root, 'build/web');
await mkdir(path.join(output, 'vendor'), {recursive: true});
const decoder = path.join(path.dirname(require.resolve('@zxing/library/package.json')), 'umd/index.min.js');
await writeFile(path.join(output, 'vendor/zxing.min.js'),
  (await readFile(decoder, 'utf8')) + '\n;\n' + (await readFile(path.join(root, 'web/zxing-settings.js'), 'utf8')));
await copyFile(path.join(path.dirname(require.resolve('@zxing/library/package.json')), 'LICENSE'), path.join(output, 'vendor/ZXING-LICENSE'));
await copyFile(path.join(path.dirname(require.resolve('workbox-build/package.json')), 'LICENSE'), path.join(output, 'vendor/WORKBOX-LICENSE'));
const version = (await readFile(path.join(root, 'pubspec.yaml'), 'utf8')).match(/^version:\s*(.+)$/m)[1].trim();
await writeFile(path.join(output, 'pwa-version.json'), JSON.stringify({version, release: process.env.PWA_RELEASE || version}));
// Flutter's own worker is not used. Workbox precaches the renderer, decoder,
// fonts, and application together, with no runtime CDN dependency.
await rm(path.join(output, 'flutter_service_worker.js'), {force: true});
const {count, size, warnings} = await generateSW({
  globDirectory: output,
  globPatterns: ['**/*'],
  globIgnores: ['**/*.map', 'sw.js', 'sw.js.map'],
  swDest: path.join(output, 'sw.js'),
  cacheId: 'orientmark-sportsman',
  cleanupOutdatedCaches: true,
  clientsClaim: true,
  skipWaiting: false,
  inlineWorkboxRuntime: true,
  sourcemap: false,
  importScripts: ['sw-idle.js'],
  maximumFileSizeToCacheInBytes: 64 * 1024 * 1024,
  navigateFallback: 'index.html',
});
if (warnings.length) throw new Error(warnings.join('\n'));
console.log(`PWA: ${count} cached files, ${(size / 1024 / 1024).toFixed(1)} MiB, base ${baseHref}`);
