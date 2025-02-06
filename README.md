# wp-codesniffer-installer

## Requirements
* PHP CLI available in PATH
* jq available in PATH (if you're using the --reset option)

## Installation

### MacOS / Linux
```
curl https://raw.githubusercontent.com/saucal/wp-codesniffer-installer/master/install-standards.sh | bash
```

If you have old standards installed (which may prevent standards to be installed on their latest versions), it's recommended to run it like this:
```
curl https://raw.githubusercontent.com/saucal/wp-codesniffer-installer/master/install-standards.sh | bash -s -- --reset
```

### Windows

Run this from either GitBash or WSL
