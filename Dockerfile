# Use an official PHP runtime with Apache as a base image
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    unzip \
    libzip-dev && \
    docker-php-ext-install zip && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2.8.3 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . /var/www/html/

# Configure Apache virtual host
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Install PHP dependencies
RUN composer install --no-dev --no-interaction --optimize-autoloader

# Enable Apache mod_rewrite and set permissions
RUN a2enmod rewrite && chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Default command
CMD ["apache2-foreground"]
