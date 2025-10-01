import { defineConfig } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy';
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';
import ViteRestart from 'vite-plugin-restart';
import fs from 'node:fs';

export default defineConfig(({ command, mode }) => {
  const isDev = command === 'serve' || mode === 'development' || process.env.NODE_ENV === 'development';

  const hasCKEditorCss = fs.existsSync('src/css/ckeditor-content.css');

  return {
    // In dev mode, we serve assets at the root of localhost:3000
    // In production, files live in the /dist directory
    base: '/dist/',
    build: {
      manifest: true,
      // Where your production files end up
      outDir: './web/dist/',
      // Enable CSS code splitting to break the dependency chain
      cssCodeSplit: true,
      // Optimize chunks for better loading
      chunkSizeWarningLimit: 1000,
      rollupOptions: {
        input: {
          app: 'src/js/app.js',
          'app-styles': 'src/css/app.scss', // Separate CSS entry with app prefix
        },
        output: {
          entryFileNames: 'assets/js/[name].[hash].js',
          chunkFileNames: 'assets/js/[name].[hash].js',
          assetFileNames: (assetInfo) => {
            if (assetInfo.name && assetInfo.name.endsWith('.css')) {
              return 'assets/css/[name].[hash][extname]';
            }
            if (assetInfo.name && (assetInfo.name.endsWith('.png') || assetInfo.name.endsWith('.jpg') || assetInfo.name.endsWith('.jpeg') || assetInfo.name.endsWith('.svg') || assetInfo.name.endsWith('.avif') || assetInfo.name.endsWith('.webp'))) {
              return 'assets/img/[name].[hash][extname]';
            }
            return 'assets/[name].[hash][extname]';
          },
          // Ensure CSS is extracted separately
          manualChunks: undefined,
        },
      },
      // Enable minification
      minify: 'terser',
      terserOptions: {
        compress: {
          drop_console: true,
          drop_debugger: true,
        },
      },
    },
    css: {
      postcss: {
        plugins: [
          tailwindcss(),
          autoprefixer(),
        ]
      }
    },
    plugins: [
      // Watch Twig templates for TailwindCSS regeneration and browser reload
      ViteRestart({
        restart: [
          'templates/**/*.twig',
        ],
        reload: [
          'templates/**/*.twig',
        ]
      }),
      viteStaticCopy({
        targets: [
          // Sync all images from src/img to web/dist/assets/img
          { src: 'src/img/*', dest: 'assets/img' },
          // Copy CKEditor CSS if it exists
          ...(
            hasCKEditorCss
              ? [{ src: 'src/css/ckeditor-content.css', dest: 'assets/css', rename: 'ckeditor-content.css' }]
              : []
          )
        ],
        watch: {
          reloadPageOnChange: true
        }
      }),
      // Note: Image optimization removed due to compatibility issues with ARM64
      // You can add vite-plugin-imagemin back if needed for your specific environment
    ],
    server: {
      host: '0.0.0.0', // Allow external connections
      port: 3000,
      strictPort: true,
      cors: true,
      origin: 'http://localhost:3000'
    }
  }
})
