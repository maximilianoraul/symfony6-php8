FROM php:8.2-fpm

#Add Symfony CLI repository
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list

#Add Node 16.x LTS repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

#Install packages
RUN apt-get update && apt-get install -y \
    git \
    libicu-dev \
    zip \
    unzip \
    libzip-dev \
    symfony-cli \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

#PHP Extensions
RUN docker-php-ext-install intl pdo pdo_mysql zip

#Yarn
RUN npm install --global yarn 

#Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

#Composer 2
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Enable local cache
RUN mkdir /.symfony && chmod 777 -R /.symfony
RUN mkdir /.symfony5 && chmod 777 -R /.symfony5
RUN mkdir /.composer && chmod 777 -R /.composer
RUN touch /.yarnrc && chmod 777 -R /.yarnrc
RUN mkdir -p /.cache/yarn && chmod 777 -R /.cache/

EXPOSE 80

WORKDIR /app
