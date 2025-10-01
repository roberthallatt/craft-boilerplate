<?php
/**
 * Yii Web Application Config
 *
 * This file is only loaded for web requests.
 */

use craft\helpers\App;

return [
    'components' => [
        'request' => function() {
            $config = craft\helpers\App::webRequestConfig();
            $config['cookieValidationKey'] = App::env('CRAFT_COOKIE_VALIDATION_KEY');
            return Craft::createObject($config);
        },
    ],
];
