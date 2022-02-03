#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

#   upload needs program
sudo apt-get -y install lighttpd php-common php-cgi php vsftpd libcurl3 php-mbstring php-curl
sudo lighty-enable-mod fastcgi-php

#   set permissions
chown -R www-data:www-data /var/www

#   edit and add config file
sed -i 's/\/var\/log\/lighttpd\/error.log//g' /etc/lighttpd/lighttpd.conf
#sed -i 's/\/var\/log\/lighttpd\/error.log/path\/to\/error.log/g' /etc/lighttpd/lighttpd.conf

PHP_CONFIG=`php -r 'echo php_ini_loaded_file();'` # тут смотря с чего запускаешь. если cli то нужно менять директории

echo display_errors = On >> $PHP_CONFIG
echo error_log = /var/www/html/log/php_errors.log >> $PHP_CONFIG
echo >> $PHP_CONFIG
echo extension=curl.so >> $PHP_CONFIG
echo extension=mbstring.so >> $PHP_CONFIG

mkdir /var/www/html/log/ -m 755
echo >> /var/www/html/log/php_errors.log
echo >> /var/www/html/log/crn_errors.log

sudo chmod 755 /etc/lighttpd/lighttpd.conf
echo server.dir-listing          = "enable" >> /etc/lighttpd/lighttpd.conf

service lighttpd force-reload
# maybe need install curl and mbstring


(crontab -l ; echo "@reboot sleep 60 /usr/bin/wget -t 3 -O - 'http://192.168.0.130/1.php' > /var/www/html/log/crn_errors.log")| crontab -
reboot
