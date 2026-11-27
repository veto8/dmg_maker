#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

show_menu() {
  printf "%s\n" '  ┌─────┬──────────────────────────────────────────────┐'
  printf "%s\n" '  │  ID │ Description                                  │'
  printf "%s\n" '  ├─────┼──────────────────────────────────────────────┤'
  printf "%s\n" '  │  1  │ Build - create dist/Example.dmg (macOS)      │'
  printf "%s\n" '  │  2  │ Clean - remove .build and dist               │'
  printf "%s\n" '  │  0  │ Exit                                         │'
  printf "%s\n" '  └─────┴──────────────────────────────────────────────┘'
}

printf "\n  dmg_maker - Task Runner\n\n"

while true; do
  show_menu

  printf "  Enter Task ID: "
  read task || exit 0

  if [ "$task" = "0" ]; then
    printf "  Goodbye!\n"
    exit 0
  fi

  if [ "$task" = "1" ]; then
    printf "...building DMG\n"
    cd "$SCRIPT_DIR" && ./make_dmg.sh
  elif [ "$task" = "2" ]; then
    printf "...cleaning\n"
    rm -rf "$SCRIPT_DIR/.build" "$SCRIPT_DIR/dist"
  else
    printf "  Unknown task: %s\n" "$task"
  fi

  sleep 2
  printf "\n"
done