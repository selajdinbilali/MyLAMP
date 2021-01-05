#!/bin/bash


sudo a2enmod ssl

sudo systemctl restart apache2

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

sudo mkdir -p /var/www/html/$1/

sudo chown -R $USER:$USER /var/www/html/$1

sudo chmod -R 755 /var/www/html

echo "<h1>"$1" works</h1>" | sudo tee /var/www/html/$1/index.html

echo "<VirtualHost *:443>
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
   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
<VirtualHost *:80>
    ServerName "$1"
    Redirect / https://"$1"/
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$1.conf

sudo a2ensite $1.conf

sudo service apache2 restart

