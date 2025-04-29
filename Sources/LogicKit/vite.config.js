import wasm from 'vite-plugin-wasm';

export default {
  build: {
    target: 'es2022',
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