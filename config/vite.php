<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => App::env('CRAFT_DEV_MODE') == 'true',
    'manifestPath' => '@webroot/manifest.json',
    'devServerInternal' => 'http://localhost:3000',
    'checkDevServer' => true,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
