#!/bin/bash

USERNAME=$(logname)
DOMAIN=$1
DELETE_FILES=${2:-0}

ROOT_PATH="/home/$USERNAME/Sites"
DOMAIN_PATH="$ROOT_PATH/$DOMAIN"
DOMAIN_CONF="$DOMAIN.conf"
DOMAIN_CONF_PATH="/etc/apache2/sites-available/$DOMAIN_CONF"

# Disable Apache entry
if [ -f "/etc/apache2/sites-enabled/$DOMAIN_CONF" ]; then
    a2dissite "$DOMAIN_CONF"
    rm -rf "$DOMAIN_CONF_PATH"
    echo "Apache entry deleted"
fi

# Remove website directory
if [ "1" == "$DELETE_FILES" ]; then
    rm -rf "$DOMAIN_PATH"
    echo "Website files deleted"
fi

