<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'VITE_DEV_SERVER_PUBLIC_PLACEHOLDER',
    'serverPublic' => '/',
    'useDevServer' => in_array(App::env('CRAFT_DEV_MODE'), [true, 'true', '1', 1], true),
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'VITE_DEV_SERVER_INTERNAL_PLACEHOLDER',
    'checkDevServer' => true,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
