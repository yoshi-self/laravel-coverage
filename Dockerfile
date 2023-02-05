FROM php:8.2-fpm-alpine

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Xdebugをインストールした後、依存パッケージを削除
RUN apk add --no-cache --virtual .xdebug-deps $PHPIZE_DEPS linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del -f .xdebug-deps

# Xdebugの設定
RUN echo 'xdebug.mode=develop,debug,coverage' >> /usr/local/etc/php/conf.d/99-xdebug.ini

COPY . /var/www/html

RUN composer install
