<?php
/**
 * Database Configuration
 *
 * All of your system's database connection settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/DbConfig.php.
 *
 * @see craft\config\DbConfig
 */

use craft\helpers\App;

return [
    'driver' => App::env('CRAFT_DB_DRIVER') ?: 'mysql',
    'server' => App::env('CRAFT_DB_SERVER') ?: 'localhost',
    'port' => App::env('CRAFT_DB_PORT') ?: 3306,
    'database' => App::env('CRAFT_DB_DATABASE') ?: 'craft',
    'user' => App::env('CRAFT_DB_USER') ?: 'root',
    'password' => App::env('CRAFT_DB_PASSWORD') ?: '',
    'schema' => App::env('CRAFT_DB_SCHEMA'),
    'tablePrefix' => App::env('CRAFT_DB_TABLE_PREFIX'),
];
