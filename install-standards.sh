#!/bin/sh

## Move to home directory
cd "${HOME}" || exit 1

### Install Composer
if [ -z "$(which composer)" ]; then
	EXPECTED_SIGNATURE="$(php -r "echo file_get_contents('https://composer.github.io/installer.sig');")"
	php -r "copy('https://getcomposer.org/installer', '$EXPECTED_SIGNATURE.php');"
	ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', '$EXPECTED_SIGNATURE.php');")"

	if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
	then
		>&2 echo 'ERROR: Invalid installer signature'
		php -r "unlink('$EXPECTED_SIGNATURE.php');"
		exit 1
	fi

	php "$EXPECTED_SIGNATURE.php" --install-dir=/usr/local/bin --filename=composer
	php -r "unlink('$EXPECTED_SIGNATURE.php');"
fi

### PHPCS
composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer global require -W "dealerdirect/phpcodesniffer-composer-installer" "phpcompatibility/php-compatibility:dev-develop" "wp-coding-standards/wpcs" "automattic/vipwpcs" "automattic/phpcs-neutron-ruleset"

phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 1
