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
      const templatesPath = resolve(process.cwd(), 'templates');
      const configPath = resolve(process.cwd(), 'config');

      // Watch templates and config directories
      server.watcher.add(templatesPath);
      server.watcher.add(configPath);

      server.watcher.on('change', (file) => {
        const relativePath = file.replace(process.cwd(), '');

        // Only watch project templates, not vendor templates
        if (file.includes('/templates/') &&
            !file.includes('/vendor/') &&
            (file.endsWith('.twig') || file.endsWith('.html'))) {
          console.log(`🔄 Template changed: ${relativePath}`);

          // Invalidate CSS modules to trigger Tailwind rebuild
          const cssModules = server.moduleGraph.getModulesByFile(
            resolve(process.cwd(), 'src/css/app.scss')
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
  // Load environment variables from .env file
  const env = loadEnv(mode, process.cwd(), '');

  // Determine if we're in development mode
  // Priority: command > NODE_ENV > mode > CRAFT_ENVIRONMENT
  const isDev = command === 'serve' ||
                (command !== 'build' && env.CRAFT_ENVIRONMENT === 'development') ||
                env.NODE_ENV === 'development' ||
                mode === 'development';

  // Check if CKEditor CSS exists
  const hasCKEditorCss = fs.existsSync(resolve(process.cwd(), 'src/css/ckeditor-content.css'));

  // Get Vite dev server configuration from environment
  const devServerUrl = env.VITE_DEV_SERVER_PUBLIC || 'http://localhost:3000';
  const devServerPort = parseInt(devServerUrl.split(':').pop() || '3000', 10);

  console.log(`📦 Vite running in ${isDev ? 'DEVELOPMENT' : 'PRODUCTION'} mode`);
  console.log(`🔧 Command: ${command}, Mode: ${mode}`);
  if (isDev) {
    console.log(`🚀 Dev server will run on: ${devServerUrl}`);
  }

  return {
    // Root directory - project root, not web folder
    root: process.cwd(),

    // Base public path - always use root
    base: '/',

    // Resolve configuration
    resolve: {
      alias: {
        '@': resolve(process.cwd(), 'src'),
        '@css': resolve(process.cwd(), 'src/css'),
        '@js': resolve(process.cwd(), 'src/js'),
        '@img': resolve(process.cwd(), 'src/img'),
      },
    },

    // Development server configuration
    server: {
      host: 'localhost',
      port: devServerPort,
      strictPort: true,
      open: false,
      cors: {
        origin: '*',
        credentials: true,
      },
      hmr: {
        host: 'localhost',
        port: devServerPort,
        protocol: 'ws',
        overlay: true,
      },
      watch: {
        usePolling: false,
        ignored: [
          '**/vendor/**',
          '**/storage/**',
          '**/web/cpresources/**',
        ],
      },
    },

    // Production build configuration
    build: {
      outDir: 'web',
      emptyOutDir: false,
      manifest: '.vite/manifest.json',
      sourcemap: isDev,
      minify: isDev ? false : 'terser',
      cssMinify: !isDev,
      rollupOptions: {
        input: {
          app: resolve(process.cwd(), 'src/js/app.js'),
        },
        output: {
          entryFileNames: 'assets/js/[name]-[hash].js',
          chunkFileNames: 'assets/js/[name]-[hash].js',
          assetFileNames: (assetInfo) => {
            const name = assetInfo.name || '';

            if (/\.(css)$/i.test(name)) {
              return 'assets/css/[name]-[hash][extname]';
            }
            if (/\.(png|jpe?g|gif|svg|webp|ico|avif)$/i.test(name)) {
              return 'assets/img/[name]-[hash][extname]';
            }
            if (/\.(woff2?|eot|ttf|otf)$/i.test(name)) {
              return 'assets/fonts/[name]-[hash][extname]';
            }

            return 'assets/[name]-[hash][extname]';
          },
        },
      },
      assetsInclude: [
        '**/*.woff2',
        '**/*.woff',
        '**/*.ttf',
        '**/*.eot',
        '**/*.otf',
      ],
      // Optimize dependencies
      commonjsOptions: {
        include: [/node_modules/],
      },
      // Target modern browsers
      target: 'es2020',
    },

    // Public directory - static assets that don't need processing
    publicDir: 'web/public',

    // CSS configuration
    css: {
      postcss: {
        plugins: [
          tailwindcss(),
          autoprefixer(),
        ],
      },
      devSourcemap: isDev,
      preprocessorOptions: {
        scss: {
          api: 'modern-compiler',
        },
      },
    },

    // Plugins
    plugins: [
      // Template watcher (development only)
      isDev && templateWatcher(),

      // Config file watcher (development only)
      isDev && ViteRestart({
        restart: [
          'tailwind.config.js',
          'vite.config.js',
        ],
        reload: [
          'templates/**/*.twig',
          'templates/**/*.html',
        ],
      }),

      // Static asset copying
      viteStaticCopy({
        targets: [
          {
            src: 'src/img/*',
            dest: 'assets/img',
          },
          // Copy CKEditor CSS if it exists
          ...(hasCKEditorCss ? [{
            src: 'src/css/ckeditor-content.css',
            dest: 'assets/css',
            rename: 'ckeditor-content.css',
          }] : []),
        ],
        watch: {
          reloadPageOnChange: isDev,
        },
      }),
    ].filter(Boolean),

    // Optimize deps
    optimizeDeps: {
      include: ['alpinejs'],
      exclude: [],
    },

    // Clear screen on dev server start
    clearScreen: false,
  };
});
