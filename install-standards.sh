#!/bin/sh

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
	>&2 echo 'ERROR: Invalid installer signature'
	rm composer-setup.php
	exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
echo $RESULT

### PHPCS
composer global require "squizlabs/php_codesniffer=*"

# Add to your .bash_profile
export PATH=$PATH:~/.composer/vendor/bin
ln -s ~/.composer/vendor/squizlabs/php_codesniffer/bin/phpcs /usr/local/bin/phpcs
ln -s ~/.composer/vendor/squizlabs/php_codesniffer/bin/phpcbf /usr/local/bin/phpcbf

#### WordPress Coding Standards
composer global require "wp-coding-standards/wpcs"
phpcs --config-set installed_paths $HOME/.composer/vendor/wp-coding-standards/wpcs
phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 0