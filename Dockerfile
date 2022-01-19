FROM php:8.1-fpm

#Add Symfony CLI repository
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list

RUN apt-get update && apt-get install -y \
    git \
    libicu-dev \
    zip \
    unzip \
    libzip-dev \
    symfony-cli \
    && rm -rf /var/lib/apt/lists/*

#PHP Extensions
RUN docker-php-ext-install intl pdo pdo_mysql zip

#Composer 2
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Enable local cache
RUN mkdir /.symfony && chmod 777 -R /.symfony
RUN mkdir /.composer && chmod 777 -R /.composer

WORKDIR /app