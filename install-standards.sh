#!/bin/sh

## Move to home directory
cd $HOME

### Install Composer
EXPECTED_SIGNATURE="$(php -r "echo file_get_contents('https://composer.github.io/installer.sig');")"
php -r "copy('https://getcomposer.org/installer', '$EXPECTED_SIGNATURE.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', '$EXPECTED_SIGNATURE.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
	>&2 echo 'ERROR: Invalid installer signature'
	php -r "unlink('$EXPECTED_SIGNATURE.php');"
	exit 1
fi

php $EXPECTED_SIGNATURE.php
php -r "unlink('$EXPECTED_SIGNATURE.php');"

### PHPCS
composer global require "dealerdirect/phpcodesniffer-composer-installer"
rm /usr/local/bin/phpcs
ln -s $HOME/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/local/bin/phpcs
rm /usr/local/bin/phpcbf
ln -s $HOME/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/local/bin/phpcbf

phpcs --config-set installed_paths $HOME/.composer/vendor

#### PHPCompatibility
composer global require "phpcompatibility/php-compatibility"

#### WordPress Coding Standards
composer global require "wp-coding-standards/wpcs"
composer global require "automattic/vipwpcs"
phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 0