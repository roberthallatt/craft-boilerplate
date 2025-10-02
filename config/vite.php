<?php

use craft\helpers\App;

$isDev = App::env('CRAFT_DEV_MODE') === 'true' || App::env('CRAFT_DEV_MODE') === true;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => $isDev, // Use dev server only in development
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'http://host.docker.internal:3000',
    'checkDevServer' => $isDev, // Only check dev server in development
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
