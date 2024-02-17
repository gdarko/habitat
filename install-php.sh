#!/bin/bash

USERNAME=$(logname)
VERSION=$1

# Basic PHP Configurations
PHP_CONF_MEMORY_LIMIT="512M"
PHP_CONF_UPLOAD_MAX_FILESIZE="256M"
PHP_CONF_POST_MAX_SIZE="512M"
PHP_CONF_MAX_EXECUTION_TIME="240"

# Install apache2
apt -y install apache2

# Install PHP with all required extensions (as per Laravel/WordPress docs)
apt -y install php$VERSION php$VERSION-fpm php$VERSION-gd php$VERSION-mbstring php$VERSION-zip php$VERSION-common php$VERSION-mysql php$VERSION-imagick php$VERSION-dom php$VERSION-xml php$VERSION-mcrypt php$VERSION-intl php$VERSION-curl php$VERSION-dev php$VERSION-bcmath libapache2-mod-php$VERSION libapache2-mod-fcgid
systemctl start php$VERSION-fpm
systemctl enable php$VERSION-fpm

# Update Apache User/Group
if [ -f "/etc/apache2/envvars" ]; then
    sed -i "s|APACHE_RUN_USER=www-data|APACHE_RUN_USER=$USERNAME|g" "/etc/apache2/envvars"
    sed -i "s|APACHE_RUN_GROUP=www-data|APACHE_RUN_GROUP=$USERNAME|g" "/etc/apache2/envvars"
fi

# Update PHP-FPM User/Group
if [ -f "/etc/php/$VERSION/fpm/pool.d/www.conf" ]; then
    sed -i "s|user = www-data|user = $USERNAME|g" "/etc/php/$VERSION/fpm/pool.d/www.conf"
    sed -i "s|group = www-data|group = $USERNAME|g" "/etc/php/$VERSION/fpm/pool.d/www.conf"
fi

# Setup PHP configuration
if [ -f "/etc/php/$VERSION/fpm/php.ini" ]; then
    if [ ! -f "/etc/php/$VERSION/fpm/php.ini.backup" ]; then
        cp "/etc/php/$VERSION/fpm/php.ini" "/etc/php/$VERSION/fpm/php.ini.backup"
    fi
    sed -i "s|memory_limit = .*|memory_limit = $PHP_CONF_MEMORY_LIMIT|g" "/etc/php/$VERSION/fpm/php.ini"
    sed -i "s|upload_max_filesize = .*|upload_max_filesize = $PHP_CONF_UPLOAD_MAX_FILESIZE|g" "/etc/php/$VERSION/fpm/php.ini"
    sed -i "s|post_max_size = .*|post_max_size = $PHP_CONF_POST_MAX_SIZE|g" "/etc/php/$VERSION/fpm/php.ini"
    sed -i "s|max_execution_time = .*|max_execution_time = $PHP_CONF_MAX_EXECUTION_TIME|g" "/etc/php/$VERSION/fpm/php.ini"
fi


# Install composer
if [ ! -f "/usr/bin/composer" ]; then
   cd tmp
   wget https://getcomposer.org/download/latest-stable/composer.phar
   mv composer.phar /usr/bin/composer
   chmod +x /usr/bin/composer
fi


# Enable apache extensions
a2enmod actions fcgid alias proxy_fcgi rewrite
systemctl restart apache2
systemctl restart php$VERSION-fpm
