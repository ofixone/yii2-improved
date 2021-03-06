FROM php:8.0-fpm-buster

WORKDIR /var/www/app

RUN apt-get update && apt-get install -y \
        nano \
        unzip \
        zlib1g-dev libzip-dev \
        libjpeg62-turbo-dev libpng-dev \
        libicu-dev \
        libpq-dev \
        cron \
        procps \
        exim4-base \
        libfreetype6-dev \
        git \
    && docker-php-ext-configure gd \
             --with-freetype=/usr/include/ \
             --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd zip intl pdo_pgsql opcache exif bcmath \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD ./docker/crontab.conf /etc/cron.d/cron-jobs
ADD ./docker/exim4.conf /etc/exim4/update-exim4.conf.conf

RUN crontab /etc/cron.d/cron-jobs && update-exim4.conf
