# Use Ubuntu as base image
FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt update
RUN apt install -y \
    apache2 \
    mysql-client \
    php \
    php-cli \
    php-mysql \
    php-curl \
    php-gd \
    php-imap \
    php-ldap \
    php-mbstring \
    php-soap \
    php-xml \
    php-zip \
    php-intl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install SuiteCRM 8.8.1
WORKDIR /var/www
RUN wget https://github.com/SuiteCRM/SuiteCRM-Core/releases/download/v8.8.1/SuiteCRM-8.8.1.zip \
    && unzip SuiteCRM-8.8.1.zip -d suitecrm && rm SuiteCRM-8.8.1.zip

# Set permissions
RUN chown -R www-data:www-data suitecrm \
    && chmod -R 755 suitecrm

# Configure Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure PHP
COPY php.ini /etc/php/8.3/apache2/php.ini

# Expose port
EXPOSE 80

# Copy initialization script
COPY init-suitecrm.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-suitecrm.sh

# Start initialization script and Apache
CMD ["/bin/bash", "-c", "/usr/local/bin/init-suitecrm.sh && apache2ctl -D FOREGROUND"]