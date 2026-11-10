import { createServer } from 'node:http';
import { readFileSync } from 'node:fs';

// Serve only the page and its configuration source, never the repository itself.
const routes = new Map([
  ['/', ['text/html; charset=utf-8', readFileSync(new URL('./index.html', import.meta.url))]],
  ['/init.lua', ['text/plain; charset=utf-8', readFileSync(new URL('../nvim/init.lua', import.meta.url))]],
]);

createServer((request, response) => {
  const route = routes.get(request.url.split('?')[0]);
  if (!['GET', 'HEAD'].includes(request.method)) {
    response.writeHead(405, { Allow: 'GET, HEAD' }).end();
    return;
  }
  if (!route) {
    response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' }).end('Not found');
    return;
  }
  response.writeHead(200, {
    'Content-Type': route[0],
    'X-Content-Type-Options': 'nosniff',
    'Cache-Control': 'no-cache',
  });
  response.end(request.method === 'HEAD' ? undefined : route[1]);
}).listen(Number(process.env.PORT || 3000), '0.0.0.0');
