<?php
$CONFIG = array (
  'instanceid' => 'oc' . substr(md5(uniqid('', true)), 0, 10),
  'passwordsalt' => 'random_salt_value_here',
  'secret' => 'random_secret_value_here',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => '127.0.0.1',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '29.0.0.10',
  'dbname' => getenv('MYSQL_DATABASE') ?: 'nextcloud',
  'dbhost' => 'mariadb',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => getenv('MYSQL_USER') ?: 'nextcloud',
  'dbpassword' => getenv('MYSQL_PASSWORD') ?: 'yourpassword',
  'installed' => true,
);
