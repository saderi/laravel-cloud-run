FROM saderi/php-nginx:latest

RUN wget "https://storage.googleapis.com/cloudsql-proxy/v1.21.0/cloud_sql_proxy.linux.amd64" -O /usr/local/bin/cloud_sql_proxy && \
    chmod +x /usr/local/bin/cloud_sql_proxy

WORKDIR /var/www/html

COPY --chown=www-data:www-data composer.* ./
RUN composer install --no-autoloader --no-dev --no-scripts

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
