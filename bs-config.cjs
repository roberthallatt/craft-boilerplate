const fs = require('fs');
const path = require('path');

// Try to use mkcert trusted certificates first, then fallback to DDEV certificates
let httpsConfig = false;

// Get the project name from DDEV config
let projectName = 'craftcms-boilerplate'; // Default fallback
try {
  const ddevConfig = fs.readFileSync('.ddev/config.yaml', 'utf8');
  const nameMatch = ddevConfig.match(/^name:\s*(.+)$/m);
  if (nameMatch) {
    projectName = nameMatch[1].trim();
  }
} catch (error) {
  console.log('⚠️  Could not read DDEV config, using default project name');
}

// Check for mkcert certificates (trusted by system)
const mkcertCertFile = path.join(__dirname, '.ddev', 'certs', 'localhost.pem');
const mkcertKeyFile = path.join(__dirname, '.ddev', 'certs', 'localhost-key.pem');

// DDEV stores certificates in ~/.ddev/traefik/certs/
const ddevCertPath = path.join(process.env.HOME || process.env.USERPROFILE, '.ddev', 'traefik', 'certs');
const ddevCertFile = path.join(ddevCertPath, `${projectName}.crt`);
const ddevKeyFile = path.join(ddevCertPath, `${projectName}.key`);

// Prefer mkcert certificates (trusted), then DDEV certificates, then self-signed
if (fs.existsSync(mkcertCertFile) && fs.existsSync(mkcertKeyFile)) {
  httpsConfig = {
    key: mkcertKeyFile,
    cert: mkcertCertFile
  };
  console.log('✅ Using trusted mkcert certificates');
} else if (fs.existsSync(ddevCertFile) && fs.existsSync(ddevKeyFile)) {
  httpsConfig = {
    key: ddevKeyFile,
    cert: ddevCertFile
  };
  console.log('⚠️  Using DDEV certificates (may show security warning)');
} else {
  // Fallback: Browser-sync will generate self-signed certificates
  httpsConfig = true;
  console.log('⚠️  Using self-signed certificates (will show security warning)');
}

module.exports = {
  proxy: `https://${projectName}.ddev.site`,
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
