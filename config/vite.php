<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => in_array(App::env('CRAFT_DEV_MODE'), [true, 'true', '1', 1], true),
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'http://localhost:3000',
    'checkDevServer' => true,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
