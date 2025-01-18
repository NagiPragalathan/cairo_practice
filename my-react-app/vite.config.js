import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import wasm from 'vite-plugin-wasm';

export default defineConfig({
  plugins: [
    react(), // React plugin
    wasm(),  // WASM support plugin
  ],
  resolve: {
    extensions: ['.js', '.jsx', '.ts', '.tsx'], // Include both JS and TS file extensions
  },
});
