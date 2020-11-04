# wp-codesniffer-installer

## Requirements
* PHP CLI available in PATH

## Installation

### MacOS (potentially linux, needs testing)
```
curl https://raw.githubusercontent.com/saucal/wp-codesniffer-installer/master/install-standards.sh | bash
```

### Windows

If you don't have composer, install it with the setup exe file from their [site](https://getcomposer.org/Composer-Setup.exe). Then:

```
composer global require "dealerdirect/phpcodesniffer-composer-installer"
composer global require "phpcompatibility/php-compatibility"
composer global require "wp-coding-standards/wpcs"
composer global require "automattic/vipwpcs"
phpcs --config-set default_standard WordPress-Extra
```
