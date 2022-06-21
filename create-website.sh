#!/bin/bash

# Constants
USERNAME=$(logname)
DOMAIN=$1
PHP_VERSION=$2
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")";
ROOT_PATH="/home/$USERNAME/Sites"
DOMAIN_PATH="$ROOT_PATH/$DOMAIN"
DOMAIN_CONF="$DOMAIN.conf"
DOMAIN_CONF_PATH="/etc/apache2/sites-available/$DOMAIN_CONF"

# Attempt to install PHP version
bash "$SCRIPT_PATH/install-php.sh" "$PHP_VERSION" 2>&1

# Create domain path
mkdir -p "$DOMAIN_PATH"
chmod -R 755 "$DOMAIN_PATH"

if [[ ! -f "$DOMAIN_PATH/index.php" ]]; then
    echo "It Works" > "$DOMAIN_PATH/index.php"
fi

chown -R "$USERNAME":"$USERNAME" "$DOMAIN_PATH"

# Create config file
cp "$SCRIPT_PATH/stubs/apache-domain.stub" "$DOMAIN_CONF_PATH"

# Replace variables
sed -i "s|{PHP_VERSION}|$PHP_VERSION|g" "$DOMAIN_CONF_PATH"
sed -i "s|{DOMAIN}|$DOMAIN|g" "$DOMAIN_CONF_PATH"
sed -i "s|{DOMAIN_PATH}|$DOMAIN_PATH|g" "$DOMAIN_CONF_PATH"

# Enable site
TEST_OUTPUT=$(apachectl -t 2>&1)
if [[ "$TEST_OUTPUT" =~ .*"Syntax OK".* ]]; then

    # First disable, if nebaled
    if [ -f "/etc/apache2/sites-enabled/$DOMAIN_CONF" ]; then
	a2dissite "$DOMAIN_CONF"
    fi

    # Enable site now
    a2ensite "$DOMAIN_CONF"

    # Add entry to the /etc/hosts file
    if ! grep -q "$DOMAIN" /etc/hosts; then
        echo "127.0.0.1  $DOMAIN" >> /etc/hosts
    fi

    # Restart Apache
    systemctl restart apache2
    echo "Site $DOMAIN created!"
else
    echo "Site not created because of config error."
fi
