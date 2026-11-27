#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")/.." && pwd)

printf "...cleaning\n"
rm -rf "$SCRIPT_DIR/.build" "$SCRIPT_DIR/dist"
