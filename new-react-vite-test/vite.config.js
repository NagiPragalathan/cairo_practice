import wasm from 'vite-plugin-wasm';
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    react(),
    wasm()
  ]
});
