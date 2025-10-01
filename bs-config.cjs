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
  https: {
    key: '.ssl/localhost-key.pem',
    cert: '.ssl/localhost.pem'
  },
  open: true,
  notify: false,
  ghostMode: false,
  reloadDelay: 100
};
