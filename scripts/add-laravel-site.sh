#!/bin/bash

echo "<VirtualHost *:80>
    ServerAdmin admin@"$1"
    ServerName "$1"
    ServerAlias www."$1"
    DocumentRoot /var/www/html/"$1"/public
    <Directory /var/www/html/"$1"/public/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        allow from all
        Require all granted
    </Directory>

    LogLevel debug
    ErrorLog /error.log
    CustomLog /access.log combined
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$1.conf

sudo a2ensite $1.conf


composer create-project --prefer-dist laravel/laravel /var/www/html/$1


sudo service apache2 restart