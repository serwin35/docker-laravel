FROM php:8.0.12-fpm-alpine

ARG PHPGROUP
ARG PHPUSER

ENV PHPGROUP=${PHPGROUP}
ENV PHPUSER=${PHPUSER}

RUN addgroup --system ${PHPGROUP}; exit 0
RUN adduser --system -G ${PHPGROUP} -s /bin/sh -D ${PHPUSER}; exit 0

ADD ./.docker/php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-install pdo pdo_mysql

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]

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
