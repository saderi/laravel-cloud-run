#!/bin/bash
set -e

nohup cloud_sql_proxy -instances=${SQL_CONNECTION_NAME}=tcp:3306 -dir=/cloudsql/ &

sed -i "s/DB_SOCKET=.*/DB_SOCKET=${MYSQL_BD_SOCKET}/g" /var/www/html/.env.example
sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/g" /var/www/html/.env.example
sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/g" /var/www/html/.env.example
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/g" /var/www/html/.env.example
sed -i "s/REDIS_HOST=.*/REDIS_HOST=${REDIS_HOST}/g" /var/www/html/.env.example

cp /var/www/html/.env.example /var/www/html/.env

php artisan key:generate --force
php artisan telescope:install
php artisan migrate --force

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

