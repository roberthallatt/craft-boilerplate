<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'https://localhost:3030',
    'serverPublic' => '/',
    'useDevServer' => in_array(App::env('CRAFT_DEV_MODE'), [true, 'true', '1', 1], true),
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'https://localhost:3030',
    'checkDevServer' => false,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
