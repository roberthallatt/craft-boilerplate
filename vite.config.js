import { defineConfig, loadEnv } from 'vite';
import { resolve } from 'path';
import fs from 'fs';
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';
import ViteRestart from 'vite-plugin-restart';
import { viteStaticCopy } from 'vite-plugin-static-copy';

// Custom plugin to watch templates and trigger CSS rebuild
function templateWatcher() {
  return {
    name: 'template-watcher',
    configureServer(server) {
      const templatesPath = resolve(__dirname, 'templates');
      const configPath = resolve(__dirname, 'config');

      // Watch templates and config directories
      server.watcher.add(templatesPath);
      server.watcher.add(configPath);

      server.watcher.on('change', (file) => {
        const relativePath = file.replace(__dirname, '');
        
        // Only watch project templates, not vendor templates
        if (file.includes('/templates/') && 
            !file.includes('/vendor/') && 
            (file.endsWith('.twig') || file.endsWith('.html'))) {
          console.log(`🔄 Template changed: ${relativePath}`);

          // Invalidate CSS modules to trigger Tailwind rebuild
          const cssModules = server.moduleGraph.getModulesByFile(
            resolve(__dirname, 'src/css/app.scss')
          );

          if (cssModules) {
            cssModules.forEach(mod => {
              server.moduleGraph.invalidateModule(mod);
            });
            console.log('🎨 CSS invalidated - Tailwind will rescan templates');
          }

          // Force full page reload for template changes
          server.ws.send({ 
            type: 'full-reload', 
            path: '*' 
          });
        }
        
        // Only watch project config changes, not vendor configs
        if (file.includes('/config/') && 
            !file.includes('/vendor/') && 
            file.endsWith('.php')) {
          console.log(`⚙️  Config changed: ${relativePath} - Consider clearing Craft caches`);
          server.ws.send({ 
            type: 'full-reload', 
            path: '*' 
          });
        }
      });

      // Add custom HMR update for better feedback
      server.ws.on('vite:beforeUpdate', (payload) => {
        console.log(`🔥 HMR Update: ${payload.updates.map(u => u.path).join(', ')}`);
      });
    }
  }
}

export default defineConfig(({ command, mode }) => {
  // Load environment variables
  const env = loadEnv(mode, process.cwd(), '');
  const isDev = command === 'serve' || mode === 'development' || process.env.NODE_ENV === 'development';
  const hasCKEditorCss = fs.existsSync('src/css/ckeditor-content.css');
  
  // Get the target URL from environment or fallback to default
  const rawTargetUrl = env.PRIMARY_SITE_URL || 'https://craftcms-boilerplate.ddev.site';
  // Ensure we have a string and remove trailing slash to prevent double slashes
  let targetUrl = String(rawTargetUrl).replace(/\/$/, '');
  
  // Validate the target URL
  if (!targetUrl || !targetUrl.startsWith('http')) {
    console.error(`❌ Invalid target URL: ${targetUrl}`);
    console.log('🔧 Using fallback URL');
    targetUrl = 'https://craftcms-boilerplate.ddev.site';
  }
  
  console.log(`🎯 Vite will proxy to: ${targetUrl}`);

  return {
    // Root directory - point to project root, not web folder
    root: '.',
    
    // Server configuration
    server: {
      port: 3000,
      strictPort: true,
      open: true, // Automatically open browser
      host: '0.0.0.0', // Allow external connections
      // CORS and headers for development
      cors: true,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
      // HMR configuration
      hmr: {
        port: 3000,
        overlay: true, // Show errors in browser overlay
        timeout: 60000 // Increase timeout to prevent connection issues
      },
      // Proxy configuration - automatically detect DDEV project
      proxy: {
        // Proxy API and admin routes to DDEV
        '^/(admin|api|cpresources|actions)': {
          target: targetUrl,
          changeOrigin: true,
          secure: false,
          ws: true
        },
        // Proxy all other requests except Vite assets
        '^(?!/(src/|@vite/|@fs/|node_modules/)).*': {
          target: targetUrl,
          changeOrigin: true,
          secure: false,
          ws: true,
          configure: (proxy, options) => {
            proxy.on('proxyReq', (proxyReq, req, res) => {
              // Log proxy requests for debugging (less verbose)
              if (isDev && !req.url.includes('/assets/')) {
                console.log(`Proxying: ${req.method} ${req.url} -> ${options.target}${req.url}`);
              }
            });
            proxy.on('error', (err, req, res) => {
              console.error(`Proxy error for ${req.url}:`, err.message);
              // Try to send a response to prevent hanging
              if (!res.headersSent) {
                res.writeHead(502, { 'Content-Type': 'text/plain' });
                res.end('Proxy Error: Could not connect to backend server');
              }
            });
            proxy.on('proxyRes', (proxyRes, req, res) => {
              // Handle proxy response errors
              if (proxyRes.statusCode >= 400) {
                console.warn(`Proxy response ${proxyRes.statusCode} for ${req.url}`);
              }
            });
          }
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
          // Sync all images from src/img to web/assets/img
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
      })
    ]
  }
})
