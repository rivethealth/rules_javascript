#!/bin/sh -e
cd "$(dirname "$0")"

rm -fr ../commonjs/fs-js
tsc -p ../commonjs/fs
rm -fr runfile-js
tsc -p runfile
rm -fr shim-js
tsc -p shim
mkdir -p shim-js/node_modules/@better_rules_javascript
ln -s $(realpath ../commonjs/fs-js) shim-js/node_modules/@better_rules_javascript/commonjs-fs
ln -s $(realpath runfile-js) shim-js/node_modules/@better_rules_javascript/nodejs-runfile
rollup -c shim.rollup.js
sed -i "s/require('pnpapi')/{}/g" shim.js
