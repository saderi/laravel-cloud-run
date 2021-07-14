FROM saderi/php-nginx:latest

RUN wget "https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64" -O /usr/local/bin/cloud_sql_proxy && \
    chmod +x /usr/local/bin/cloud_sql_proxy

WORKDIR /var/www/html

COPY --chown=www-data:www-data . .

RUN npm ci && \
    npm run prod

RUN chown -R :www-data /var/www/html/storage/ \
                       /var/www/html/bootstrap/cache/ && \
    chmod -R g+w /var/www/html/storage/ \
                 /var/www/html/bootstrap/cache/

RUN composer install

RUN mv .docker/docker-php-entrypoint.sh /usr/local/bin/docker-php-entrypoint  && \
    chmod o+x /usr/local/bin/docker-php-entrypoint

CMD ["docker-php-entrypoint"]


