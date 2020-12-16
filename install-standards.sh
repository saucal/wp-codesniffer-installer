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

php $EXPECTED_SIGNATURE.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('$EXPECTED_SIGNATURE.php');"

### PHPCS
composer global require -W "dealerdirect/phpcodesniffer-composer-installer:0.7.0" "phpcompatibility/php-compatibility" "wp-coding-standards/wpcs" "automattic/vipwpcs" "woocommerce/woocommerce-sniffs"
GLOBAL_COMPOSER_PATH=$(composer global config home --quiet)
rm /usr/local/bin/phpcs
rm /usr/local/bin/phpcbf
ln -s "${GLOBAL_COMPOSER_PATH}/vendor/squizlabs/php_codesniffer/bin/phpcs" /usr/local/bin/phpcs
ln -s "${GLOBAL_COMPOSER_PATH}/vendor/squizlabs/php_codesniffer/bin/phpcbf" /usr/local/bin/phpcbf

phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 1
