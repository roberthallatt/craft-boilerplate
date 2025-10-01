<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => App::env('CRAFT_ENVIRONMENT') === 'development',
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'http://host.docker.internal:3000',
    'checkDevServer' => true,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
