# wp-codesniffer-installer

## Requirements
* PHP CLI available in PATH

## Installation

### MacOS / Linux
```
curl https://raw.githubusercontent.com/saucal/wp-codesniffer-installer/master/install-standards.sh | bash
```

### Windows

If you don't have composer, install it with the setup exe file from their [site](https://getcomposer.org/Composer-Setup.exe). Then:

```
composer global require -W "dealerdirect/phpcodesniffer-composer-installer:0.7.0" "phpcompatibility/php-compatibility" "wp-coding-standards/wpcs" "automattic/vipwpcs" "woocommerce/woocommerce-sniffs"
phpcs --config-set default_standard WordPress-Extra
phpcs --config-set show_warnings 1
```
