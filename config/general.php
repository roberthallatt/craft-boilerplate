<?php
/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 *
 * @see \craft\config\GeneralConfig
 */

use craft\helpers\App;

$isDev = App::env('CRAFT_ENVIRONMENT') === 'development' || App::env('CRAFT_DEV_MODE') === 'true' || App::env('CRAFT_DEV_MODE') === true;
$isProd = App::env('CRAFT_ENVIRONMENT') === 'production';

$config = [
    // Set the default week start day for date pickers (0 = Sunday, 1 = Monday, etc.)
    'defaultWeekStartDay' => 1,
    
    // Prevent generated URLs from including "index.php"
    'omitScriptNameInUrls' => true,
    
    // Enable Dev Mode (see https://craftcms.com/guides/what-dev-mode-does)
    'devMode' => $isDev,
    
    // Allow administrative changes
    'allowAdminChanges' => $isDev,
    
    // Disallow robots
    'disallowRobots' => $isDev,
    
    
    // Set the @webroot alias so the clear-caches command knows where to find CP resources
    'aliases' => [
        '@webroot' => dirname(__DIR__) . '/web',
    ],
];

// Add environment-specific settings
if ($isDev) {
    $config['enableTemplateCaching'] = false;
    $config['testToEmailAddress'] = 'test@example.com';
    
    // Performance optimizations for development
    $config['maxCachedCloudImageSize'] = 2000;
    $config['defaultImageQuality'] = 82;
    $config['optimizeImageFilesize'] = false;
    $config['generateTransformsBeforePageLoad'] = true;
    $config['enableGql'] = false; // Disable GraphQL if not needed
}

if ($isProd) {
    // $config['enableTemplateCaching'] = true;
    $config['allowUpdates'] = false;
}

return $config;
