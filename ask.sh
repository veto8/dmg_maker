#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

show_menu() {
  printf "%s\n" '  ┌─────┬──────────────────────────────────────────────┐'
  printf "%s\n" '  │  ID │ Description                                  │'
  printf "%s\n" '  ├─────┼──────────────────────────────────────────────┤'
  printf "%s\n" '  │  1  │ Setup - check/install requirements (macOS)   │'
  printf "%s\n" '  │  2  │ Build - create dist/Example.dmg (macOS)      │'
  printf "%s\n" '  │  3  │ Clean - remove .build and dist               │'
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
    "$SCRIPT_DIR/ask.d/setup.sh"
  elif [ "$task" = "2" ]; then
    "$SCRIPT_DIR/ask.d/build.sh"
  elif [ "$task" = "3" ]; then
    "$SCRIPT_DIR/ask.d/clean.sh"
  else
    printf "  Unknown task: %s\n" "$task"
  fi

  sleep 2
  printf "\n"
done
