#! /usr/bin/env sh

cd Sources/lxui; npm install; npm update; npm run build
cd /usr/share/nginx/html/; rm -r lxui; mv /build .; mv build/ lxui