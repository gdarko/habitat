#!/bin/bash

VERSION=$1
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")";

# Attempt to install PHP version
bash "$SCRIPT_PATH/install-php.sh" "$PHP_VERSION" 2>&1

# Switch the version now
PHP_CMD_PATH="/usr/bin/php$VERSION"

if [[ ! -f "$PHP_CMD_PATH" ]]; then
    echo "PHP Version $VERSION not found in $PHP_CMD_PATH\n"
else
    update-alternatives --set php "$PHP_CMD_PATH"
    echo "PHP Version switched to $VERSION\n"
fi

