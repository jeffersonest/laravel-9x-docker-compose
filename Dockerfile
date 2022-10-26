FROM php:8.0-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ARG app_name

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www/html

EXPOSE 8000

USER $user

RUN composer create-project laravel/laravel /var/www/html --remove-vcs

COPY .env .

RUN composer install

RUN php artisan optimize:clear

RUN php artisan key:generate

