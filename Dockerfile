FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && docker-php-ext-install mysqli

COPY nginx.conf /etc/nginx/nginx.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WORDPRESS_DB_HOST=mysql:3306
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=wordpress
ENV WORDPRESS_DB_NAME=wordpress

RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz \
    && rm wordpress.tar.gz \
    && mv wordpress/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html

# RUN sed -i '2i echo "bugを修正のところ";' /var/www/html/wp-admin/setup-config.php

# COPY wp-config.php /var/www/html/wp-config.php

EXPOSE 80

CMD ["supervisord", "-n"]