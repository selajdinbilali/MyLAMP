#!/bin/bash
sudo mkdir -p /var/www/html/$1/

sudo chown -R $USER:$USER /var/www/html/$1

sudo chmod -R 755 /var/www/html

echo "<h1>"$1" works</h1>" | sudo tee /var/www/html/$1/index.html

echo "<VirtualHost *:80>
    ServerAdmin admin@"$1"
    ServerName "$1"
    ServerAlias www."$1"
    DocumentRoot /var/www/html/"$1"
    LogLevel debug
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    <Directory /var/www/html/"$1">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
	allow from all
        Require all granted
    </Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$1.conf

sudo a2ensite $1.conf

sudo service apache2 restart

