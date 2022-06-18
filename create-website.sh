#!/bin/bash

# Constants
USERNAME=$(logname)
DOMAIN=$1
PHP_VERSION=$2
ROOT_PATH="/home/$USERNAME/Sites"
DOMAIN_PATH="$ROOT_PATH/$DOMAIN"
DOMAIN_CONF="$DOMAIN.conf"
DOMAIN_CONF_PATH="/etc/apache2/sites-available/$DOMAIN_CONF"

# Attempt to install PHP version
bash "$PWD/install-php.sh" "$PHP_VERSION" 2>&1

# Create domain path
mkdir -p "$DOMAIN_PATH"
chmod -R 755 "$DOMAIN_PATH"
echo "It Works" > "$DOMAIN_PATH/index.php"
chown -R "$USERNAME":"$USERNAME" "$DOMAIN_PATH"

# Create config file
cp stubs/apache-domain.stub "$DOMAIN_CONF_PATH"

# Replace variables
sed -i "s|{PHP_VERSION}|$PHP_VERSION|g" "$DOMAIN_CONF_PATH"
sed -i "s|{DOMAIN}|$DOMAIN|g" "$DOMAIN_CONF_PATH"
sed -i "s|{DOMAIN_PATH}|$DOMAIN_PATH|g" "$DOMAIN_CONF_PATH"

# Enable site
TEST_OUTPUT=$(apachectl -t 2>&1)


if [[ "$TEST_OUTPUT" =~ .*"Syntax OK".* ]]; then
    if [ -f "/etc/apache2/sites-enabled/$DOMAIN_CONF" ]; then
	a2dissite "$DOMAIN_CONF"
    fi
    a2ensite "$DOMAIN_CONF"
    if ! grep -q "$DOMAIN" /etc/hosts; then
        echo "127.0.0.1  $DOMAIN" >> /etc/hosts
    fi

    systemctl restart apache2
    echo "Site $DOMAIN created!"
else
    echo "Site not created because of config error."
fi
