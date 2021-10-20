#!/bin/sh -e
cd "$(dirname "$0")"

rm -fr ../commonjs/fs-js
tsc -p ../commonjs/fs
rm -fr fs-gen-js
tsc -p fs-gen
mkdir -p fs-gen-js/node_modules/@better_rules_javascript
ln -s $(realpath ../commonjs/fs-js) fs-gen-js/node_modules/@better_rules_javascript/commonjs-fs
rollup -c fs-gen.rollup.js
