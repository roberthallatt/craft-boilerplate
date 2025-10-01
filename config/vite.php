<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => true, // Force dev server usage
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'http://host.docker.internal:3000',
    'checkDevServer' => false, // Don't check, just use it
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
