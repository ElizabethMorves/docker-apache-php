FROM php:7.4.8-apache

 MAINTAINER Uzh0r <Elizabeth.Morves@gmail.com>
 ENV DEBIAN_FRONTEND noninteractive
 ENV LOCALE ja_JP.UTF-8
 ENV DEFAULT_ROOT=/var/www/html

RUN apt -y update && apt upgrade -y \
 && apt --no-install-recommends install -y --fix-missing \
    apt-utils \
    pkg-config \
    locales \
    tzdata \
    libicu-dev \
    libmcrypt-dev \
    libcurl3-openssl-dev \
    libz-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    libmagickwand-dev \
    libzip-dev \
 && sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen \
 && echo "LANG=$LOCALE">/etc/default/locale \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=$LOCALE \
 && a2enmod rewrite \
 && a2enmod remoteip \
 && pecl install \
    xdebug \
    mcrypt \
    redis \
    imagick \
    timezonedb \
    oauth \
 && docker-php-ext-configure intl \
 && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
 && docker-php-ext-install \
    intl \
    -j$(nproc) gd \
    mysqli \
    exif \
    bcmath \
    zip \
 && docker-php-ext-enable \
    xdebug \
    mcrypt \
    opcache \
    redis \
    imagick \
    timezonedb \
 && echo "<?php \n\n phpinfo();" > $DEFAULT_ROOT/index.php \
 && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && rm -rf /var/lib/apt/lists/*
