#!/usr/bin/env bash

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

while read_dom; do
    if [[ "$ENTITY" = "version" ]]; then
        echo "$CONTENT"
        exit
    fi
done < pom.xml
