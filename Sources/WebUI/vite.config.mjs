import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';

export default defineConfig(({ command }) => {
  const isBuild = command === 'build';

  return {
    plugins: [react(), tsconfigPaths()],
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: './vitest.setup.mjs',
    },
    build: {
      minify: true,
      target: "ES2022"
    },
    esbuild: isBuild
      ? {
        // removes all logs from the build
        drop: ["console", "debugger"]
      }
      : {},
    server: {
      proxy: {
        '/api': {
          target: 'http://127.0.0.1:1337',
          changeOrigin: true,
          secure: false,
          ws: true,
          configure: (proxy, _options) => {
            proxy.on('error', (err, _req, _res) => {
              console.log('proxy error', err);
            });
            proxy.on('proxyReq', (proxyReq, req, _res) => {
              console.log('Sending Request to the Target:', req.method, req.url);
            });
            proxy.on('proxyRes', (proxyRes, req, _res) => {
              console.log('Received Response from the Target:', proxyRes.statusCode, req.url);
            });
          },
        }
      }
    }
  };
});
