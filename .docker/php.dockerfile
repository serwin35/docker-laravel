FROM php:7.4-fpm-alpine

ADD ./.docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

#Install imagemagick:
ENV MAGICK_HOME=/usr

RUN  apk --no-cache update \
        && apk --no-cache upgrade \
        && apk add --update \
        coreutils \
        freetype-dev \
        libwebp-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        libzip-dev \
        jpeg-dev \
        icu-dev \
        curl-dev \
        imap-dev \
        libxslt-dev libxml2-dev \
        postgresql-dev \
        libgcrypt-dev \
        oniguruma-dev \
        libpng \
        libpng-dev \
        zlib-dev \
        libxpm-dev \
        libxml2-dev \
        gd \
        autoconf g++ imagemagick-dev imagemagick libtool make

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure imap
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache
RUN docker-php-ext-install soap
RUN docker-php-ext-install pdo pdo_mysql
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN apk del autoconf g++ libtool make
RUN docker-php-ext-install -j "$(nproc)" \
                gd soap imap bcmath mbstring iconv curl sockets \
                opcache \
                pdo_pgsql \
                xsl \
                exif \
                mysqli pdo pdo_mysql \
                intl \
                zip
