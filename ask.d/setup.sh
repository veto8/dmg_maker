#!/bin/sh

missing=0

for cmd in hdiutil qlmanage osascript; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "ok    %s\n" "$cmd"
  else
    printf "FAIL  %s missing\n" "$cmd"
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  case "$(uname -s)" in
    Darwin*)
      printf "Install Xcode Command Line Tools: xcode-select --install\n"
      ;;
    *)
      printf "FAIL  this project requires macOS\n"
      ;;
  esac
  exit 1
fi

printf "ok    all requirements present\n"
