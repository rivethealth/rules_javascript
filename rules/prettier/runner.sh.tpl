#!/bin/bash -e
arg="$1"

function format {
    if [ "$arg" = write ]; then
        if ! diff -q "$1" "$2"; then
            echo "$1"
            cp "$2" "$1"
        fi
    else
        diff "$1" "$2" || true
    fi
}

%{files}
