FROM php:8.1-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

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
        autoconf g++ libtool make

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

RUN docker-php-ext-configure intl
RUN docker-php-ext-configure imap
RUN docker-php-ext-configure imap
RUN docker-php-ext-configure xml
RUN docker-php-ext-configure simplexml
RUN docker-php-ext-configure xmlreader
RUN docker-php-ext-install imap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install curl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install opcache
RUN docker-php-ext-install soap
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install xsl
RUN docker-php-ext-install exif
RUN docker-php-ext-install zip

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar -zxvf -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
