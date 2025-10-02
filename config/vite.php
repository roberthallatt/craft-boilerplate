<?php

use craft\helpers\App;

$isDev = App::env('CRAFT_DEV_MODE') === 'true' || App::env('CRAFT_DEV_MODE') === true;

return [
    'devServerPublic' => App::env('VITE_DEV_SERVER_PUBLIC') ?: 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => $isDev,
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => App::env('VITE_DEV_SERVER_INTERNAL') ?: 'http://host.docker.internal:3000',
    'checkDevServer' => true, // Always check if dev server is running
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
