import { spawn, execFileSync } from 'node:child_process';
import { openSync, closeSync } from 'node:fs';
import { resolve, dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { tmpdir } from 'node:os';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const port = Number(process.env.TUTO_PREVIEW_PORT || 4180);
if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('TUTO_PREVIEW_PORT must be between 1 and 65535.');
const url = `http://127.0.0.1:${port}/`;
async function probe() {
  let response;
  try { response = await fetch(url, { signal: AbortSignal.timeout(1500), redirect: 'manual' }); }
  catch { return 'offline'; }
  const html = await response.text();
  if (response.status === 200 && html.includes('<title>Tuto — Túi giữ tiền thông minh</title>') && html.includes('id="main"') && html.includes('id="dialog"')) return 'tuto';
  return 'occupied';
}
const current = await probe();
if (current === 'tuto') {
  console.log(`Tuto preview is already running: ${url}`);
} else {
  if (current === 'occupied') throw new Error(`Port ${port} is occupied by another service. It was left unchanged.`);
  execFileSync(process.execPath, ['build.mjs'], { cwd: root, stdio: 'inherit' });
  const logfile = join(tmpdir(), `tuto-preview-${port}.log`);
  const fd = openSync(logfile, 'a');
  const child = spawn('python3', ['-m', 'http.server', String(port), '--bind', '0.0.0.0', '--directory', resolve(root, 'dist')], { cwd: root, detached: true, stdio: ['ignore', fd, fd] });
  closeSync(fd);
  let launchError;
  child.on('error', error => { launchError = error; });
  child.unref();
  let ready = false;
  for (let attempt = 0; attempt < 30; attempt++) {
    if (launchError) throw launchError;
    const status = await probe();
    if (status === 'tuto') { ready = true; break; }
    if (status === 'occupied') throw new Error(`Port ${port} is occupied by another service. It was left unchanged.`);
    await new Promise(resolve => setTimeout(resolve, 200));
  }
  if (!ready) throw new Error(`Tuto preview did not become ready. Check ${logfile}.`);
  console.log(`Tuto preview is ready: ${url}`);
  console.log(`Tuto preview PID: ${child.pid}`);
  console.log(`Log: ${logfile}`);
}
console.log(`In Codespaces, open Ports → ${port} → Open in Browser. Keep port visibility Private.`);
console.log('This local health check does not verify GitHub port authentication.');
