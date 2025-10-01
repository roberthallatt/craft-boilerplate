<?php

use craft\helpers\App;

return [
    'devServerPublic' => 'http://localhost:3000',
    'serverPublic' => '/',
    'useDevServer' => true,
    'manifestPath' => '@webroot/.vite/manifest.json',
    'devServerInternal' => 'http://host.docker.internal:3000',
    'checkDevServer' => false,
    'errorEntry' => '',
    'includeReactRefreshShim' => false,
    'includeModulePreloadShim' => true,
];
