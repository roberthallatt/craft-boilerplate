import { defineConfig } from 'vite';
import { resolve } from 'path';
import fs from 'fs';
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';
import ViteRestart from 'vite-plugin-restart';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import basicSsl from '@vitejs/plugin-basic-ssl';

// Custom plugin to watch templates and trigger CSS rebuild
function templateWatcher() {
  return {
    name: 'template-watcher',
    configureServer(server) {
      // Watch template directory
      server.watcher.add(resolve(__dirname, 'templates/**/*.twig'));

      server.watcher.on('change', async (file) => {
        if (file.endsWith('.twig') || file.endsWith('.html')) {
          console.log(`🔄 Template changed: ${file}`);

          // Invalidate the CSS module so Tailwind rescans
          const cssModule = server.moduleGraph.getModulesByFile(
            resolve(__dirname, 'src/css/app.scss')
          );

          if (cssModule && cssModule.size > 0) {
            cssModule.forEach(mod => {
              server.moduleGraph.invalidateModule(mod);
            });
          }

          // Trigger HMR update
          server.ws.send({
            type: 'update',
            updates: Array.from(cssModule || []).map(mod => ({
              type: 'css-update',
              path: mod.url,
              acceptedPath: mod.url,
              timestamp: Date.now()
            }))
          });
        }
      });
    }
  }
}

export default defineConfig(({ command, mode }) => {
  const isDev = command === 'serve' || mode === 'development' || process.env.NODE_ENV === 'development';
  const hasCKEditorCss = fs.existsSync('src/css/ckeditor-content.css');

  return {
    // Root directory - point to project root, not web folder
    root: '.',
    
    // Server configuration
    server: {
      port: 3000,
      strictPort: true,
      open: false,
      // Disable HTTPS for now to avoid certificate issues
      https: false,
      // Allow all origins and methods
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
      cors: true,
      // HMR configuration - use WebSocket for HTTP
      hmr: {
        protocol: 'ws',
        host: 'localhost',
        port: 3000,
        clientPort: 3000,
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
      manifest: '.vite/manifest.json',
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
      // Custom plugin to watch templates and trigger CSS rebuild
      templateWatcher(),
      
      // Watch config files and templates for CSS regeneration
      ViteRestart({
        restart: [
          'tailwind.config.js',
          'vite.config.js'
        ],
        reload: [
          'templates/**/*.twig',
          'templates/**/*.html'
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
