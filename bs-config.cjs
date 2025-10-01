const fs = require('fs');
const path = require('path');

// Try to use DDEV's SSL certificates if available
let httpsConfig = false;

// DDEV stores certificates in ~/.ddev/traefik/certs/
const ddevCertPath = path.join(process.env.HOME || process.env.USERPROFILE, '.ddev', 'traefik', 'certs');
const certFile = path.join(ddevCertPath, 'craftcms-boilerplate.crt');
const keyFile = path.join(ddevCertPath, 'craftcms-boilerplate.key');

// Check if DDEV certificates exist
if (fs.existsSync(certFile) && fs.existsSync(keyFile)) {
  httpsConfig = {
    key: keyFile,
    cert: certFile
  };
} else {
  // Fallback: Browser-sync will generate self-signed certificates
  httpsConfig = true;
}

module.exports = {
  proxy: 'https://craftcms-boilerplate.ddev.site',
  files: [
    'templates/**/*.twig',
    'web/dist/**/*.css',
    'web/dist/**/*.js'
  ],
  port: 3001,
  ui: {
    port: 3002
  },
  https: httpsConfig,
  open: true,
  notify: false,
  ghostMode: false,
  reloadDelay: 100,
  // Additional options for better DDEV integration
  reloadOnRestart: true,
  injectChanges: true,
  // Handle self-signed certificate issues
  rejectUnauthorized: false
};
