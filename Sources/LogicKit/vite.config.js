import wasm from 'vite-plugin-wasm';

export default {
  build: {
    target: 'es2022',
    outDir: 'dist',
    rollupOptions: {
      input: './src/runtime.ts',
      output: {
        entryFileNames: 'runtime.js',
        format: 'es',
      },
    },
  },
  plugins: [wasm()],
}