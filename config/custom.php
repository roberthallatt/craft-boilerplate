<?php
/**
 * Custom Configuration
 *
 * Custom configuration settings for templates and other components.
 */

use craft\helpers\App;

return [
    // Vite development server configuration for templates
    'viteDevServerPublic' => App::env('VITE_DEV_SERVER_PUBLIC') ?: 'http://localhost:3000',
];
