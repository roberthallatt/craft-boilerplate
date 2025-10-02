<?php

use craft\helpers\App;

return [
    'devServerPublic' => App::env('VITE_DEV_SERVER_PUBLIC') ?: 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => App::env('CRAFT_DEV_MODE') === 'true' || App::env('CRAFT_ENVIRONMENT') === 'development',
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => App::env('VITE_DEV_SERVER_INTERNAL') ?: 'http://host.docker.internal:3000',
    'checkDevServer' => App::env('CRAFT_DEV_MODE') === 'true' || App::env('CRAFT_ENVIRONMENT') === 'development',
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
