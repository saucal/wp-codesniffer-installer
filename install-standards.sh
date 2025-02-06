#!/bin/bash

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

PACKAGES_TO_REMOVE=();
PACKAGES_TO_INSTALL=( "dealerdirect/phpcodesniffer-composer-installer" "phpcompatibility/php-compatibility:dev-develop" "wp-coding-standards/wpcs" "automattic/vipwpcs" "automattic/phpcs-neutron-ruleset" );

if [ "$1" == "--reset" ]; then
	if [ -z "$(which jq)" ]; then
		echo "RESETTING REQUIRES jq" >&2
		exit 1
	fi

	echo "Resetting PHP Code Sniffer Standards..."

	ALL_GLOBAL_PACKAGES="$(composer global show -D -f json 2>/dev/null | jq -r '.installed[].name')"

	PACKAGES_TO_REMOVE=();

	# loop pacakges and remove them
	for PACKAGE in $ALL_GLOBAL_PACKAGES; do
		TYPE="$(composer global show -D -f json "$PACKAGE" 2>/dev/null | jq -r '.type')"
		if [ "$TYPE" = "phpcodesniffer-standard" ]; then
			for STANDARD in "${PACKAGES_TO_INSTALL[@]}"; do
				STANDARD="${STANDARD%%:*}"
				if [ "$PACKAGE" = "$STANDARD" ]; then
					continue 2
				fi
			done
			PACKAGES_TO_REMOVE+=("$PACKAGE")
		fi
	done

	if [ "${#PACKAGES_TO_REMOVE[@]}" -gt 0 ]; then
		# remove packages

		echo "REMOVING STANDARDS..." "${PACKAGES_TO_REMOVE[@]}"
		composer global remove -W "${PACKAGES_TO_REMOVE[@]}" >/dev/null 2>&1
		echo "DONE"
	else
		echo "NO STANDARDS TO REMOVE"
	fi
fi

### PHPCS

echo "Installing PHP Code Sniffer Standards..."

composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer global require -W "${PACKAGES_TO_INSTALL[@]}"

phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 1
