import { defineConfig } from 'vite';
import { resolve } from 'path';
import fs from 'fs';
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';
import ViteRestart from 'vite-plugin-restart';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import basicSsl from '@vitejs/plugin-basic-ssl';

export default defineConfig(({ command, mode }) => {
  const isDev = command === 'serve' || mode === 'development' || process.env.NODE_ENV === 'development';
  const hasCKEditorCss = fs.existsSync('src/css/ckeditor-content.css');

  return {
    // Root directory - point to project root, not web folder
    root: '.',
    
    // Server configuration
    server: {
      port: 3030,
      strictPort: true,
      open: false,
      // Enable HTTPS with mkcert certificates if available
      https: fs.existsSync('.ddev/certs/localhost.pem') ? {
        key: fs.readFileSync('.ddev/certs/localhost-key.pem'),
        cert: fs.readFileSync('.ddev/certs/localhost.pem'),
      } : true, // Fallback to basic SSL
      // Allow all origins
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      // HMR configuration
      hmr: {
        protocol: 'wss',
        host: 'localhost',
        port: 3030,
        clientPort: 3030,
        timeout: 120000,
        overlay: false
      },
      // Proxy all requests not handled by Vite to the CMS
      proxy: {
        '^(?!/(@vite|src|node_modules))': {
          target: 'https://localhost',
          changeOrigin: true,
          secure: false
        }
      }
    },

    // Build configuration
    build: {
      outDir: 'web',
      emptyOutDir: false,
      manifest: true,
      rollupOptions: {
        input: {
          app: resolve(__dirname, 'src/js/app.js')
        },
        output: {
          entryFileNames: 'assets/js/[name]-[hash].js',
          assetFileNames: (assetInfo) => {
            if (/\.(css)$/i.test(assetInfo.name)) {
              return `assets/css/[name]-[hash][extname]`
            }
            if (/\.(png|jpe?g|gif|svg|webp|ico)$/i.test(assetInfo.name)) {
              return `assets/img/[name]-[hash][extname]`
            }
            if (/\.(woff2?|eot|ttf|otf)$/i.test(assetInfo.name)) {
              return `assets/fonts/[name]-[hash][extname]`
            }
            return `assets/[name]-[hash][extname]`
          },
          chunkFileNames: 'assets/js/[name]-[hash].js',
        },
      },
      assetsInclude: ['**/*.woff2', '**/*.woff', '**/*.ttf', '**/*.eot', '**/*.otf']
    },

    // Public directory handling
    publicDir: 'web/public',
    
    css: {
      postcss: {
        plugins: [
          tailwindcss(),
          autoprefixer(),
        ]
      },
      devSourcemap: true
    },
    
    plugins: [
      // Watch config files and templates for CSS regeneration
      ViteRestart({
        restart: [
          'tailwind.config.js',
          'vite.config.js'
        ],
        reload: [
          'templates/**/*.twig'
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
          ),
        ],
        watch: {
          reloadPageOnChange: true
        }
      }),
      basicSsl()
    ]
  }
})
