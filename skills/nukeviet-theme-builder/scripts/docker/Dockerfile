FROM php:8.2-fpm-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev \
        libzip-dev libicu-dev libonig-dev libcurl4-openssl-dev \
        unzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        mysqli pdo_mysql gd zip intl mbstring opcache \
    && docker-php-ext-enable opcache \
    && rm -rf /var/lib/apt/lists/*

# Recommended PHP settings for NukeViet
RUN { \
      echo 'upload_max_filesize=64M'; \
      echo 'post_max_size=64M'; \
      echo 'memory_limit=256M'; \
      echo 'max_execution_time=120'; \
      echo 'date.timezone=Asia/Ho_Chi_Minh'; \
    } > /usr/local/etc/php/conf.d/nukeviet.ini \
 && { \
      echo 'opcache.enable=1'; \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.validate_timestamps=1'; \
    } > /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/html
