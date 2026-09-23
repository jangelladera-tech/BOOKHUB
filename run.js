import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const isWin = process.platform === 'win32';
const npmCmd = isWin ? 'npm.cmd' : 'npm';
const npxCmd = isWin ? 'npx.cmd' : 'npx';

console.log('====================================================');
console.log('       📚 INICIANDO BOOKHUB (FULLSTACK APP)         ');
console.log('====================================================');

// 1. Start Server
const serverDir = path.join(__dirname, 'server');
const serverProc = spawn('node', ['server.js'], {
  cwd: serverDir,
  stdio: 'pipe',
  shell: isWin
});

serverProc.stdout.on('data', (data) => {
  const lines = data.toString().trim().split('\n');
  lines.forEach(line => console.log(`\x1b[36m[SERVER]\x1b[0m ${line}`));
});

serverProc.stderr.on('data', (data) => {
  const lines = data.toString().trim().split('\n');
  lines.forEach(line => console.error(`\x1b[31m[SERVER ERROR]\x1b[0m ${line}`));
});

// 2. Start Client (Vite)
const clientDir = path.join(__dirname, 'client');
const clientProc = spawn(npxCmd, ['vite', '--host', '0.0.0.0'], {
  cwd: clientDir,
  stdio: 'pipe',
  shell: isWin
});

clientProc.stdout.on('data', (data) => {
  const lines = data.toString().trim().split('\n');
  lines.forEach(line => console.log(`\x1b[35m[CLIENT]\x1b[0m ${line}`));
});

clientProc.stderr.on('data', (data) => {
  const lines = data.toString().trim().split('\n');
  lines.forEach(line => console.error(`\x1b[33m[CLIENT WARN]\x1b[0m ${line}`));
});

const cleanup = () => {
  console.log('\nDeteniendo BookHub...');
  if (isWin) {
    if (serverProc.pid) spawn('taskkill', ['/pid', serverProc.pid, '/f', '/t']);
    if (clientProc.pid) spawn('taskkill', ['/pid', clientProc.pid, '/f', '/t']);
  } else {
    serverProc.kill('SIGINT');
    clientProc.kill('SIGINT');
  }
  process.exit();
};

process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);
