#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")/.." && pwd)

printf "...building DMG\n"
cd "$SCRIPT_DIR" && ./make_dmg.sh
