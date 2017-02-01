#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install wordpress apache2 mysql-server php5 php5-mysql

echo "Alias /wp/wp-content /var/lib/wordpress/wp-content
Alias /wp /usr/share/wordpress
<Directory /usr/share/wordpress>
  Options FollowSymLinks
  AllowOverride Limit Options FileInfo
  DirectoryIndex index.php
  Require all granted
</Directory>
<Directory /var/lib/wordpress/wp-content>
  Options FollowSymLinks
  Require all granted
</Directory>" > /etc/apache2/sites-available/wp.conf
a2ensite wp
service apache2 reload

mysql -u root -e "CREATE DATABASE wordpress"
mysqladmin -u root password "$1"

echo "<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'root');
define('DB_PASSWORD', '$1');
define('DB_HOST', 'localhost');
define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');" > /etc/wordpress/config-default.php
