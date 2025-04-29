import wasm from 'vite-plugin-wasm';

export default {
  build: {
    target: 'esnext',
    outDir: 'dist',
    rollupOptions: {
      input: './src/index.ts',
      output: {
        entryFileNames: 'index.js',
        format: 'es',
      },
    },
  },
  plugins: [wasm()],
}