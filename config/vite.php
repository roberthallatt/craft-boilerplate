<?php

use craft\helpers\App;

return [
    'useDevServer' => App::env('CRAFT_ENVIRONMENT') === 'development',
    'manifestPath' => '@webroot/dist/.vite/manifest.json',
    'devServerPublic' => App::env('VITE_DEV_SERVER_PUBLIC') ?: 'http://localhost:3000',
    'devServerInternal' => App::env('VITE_DEV_SERVER_INTERNAL') ?: 'http://localhost:3000',
    'checkDevServer' => true,
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
    'criticalPath' => '@webroot/dist/criticalcss',
    'criticalSuffix' =>'_critical.min.css',
    'errorEntry' => '',
    'cacheKeySuffix' => '',
    'serverPublic' => '/dist/',
];
