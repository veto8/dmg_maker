#!/bin/sh
set -eu

ROOT=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT"

APP="${1:-App/Example.app}"
OUT="${2:-dist/Example.dmg}"
VOLNAME="${VOLNAME:-Example}"

[ -d "$APP" ] || { printf "app not found: %s\n" "$APP" >&2; exit 1; }

APPNAME=$(basename "$APP")
APPNAME=${APPNAME%.app}

BUILD="$ROOT/.build"
rm -rf "$BUILD"
mkdir -p "$BUILD" "$(dirname "$OUT")"
rm -f "$OUT"

STAGE="$BUILD/src"
DMG_TMP="$BUILD/tmp.dmg"
MOUNT=""

cleanup() {
  [ -n "$MOUNT" ] && hdiutil detach "$MOUNT" -force >/dev/null 2>&1 || true
  rm -rf "$BUILD"
}
trap cleanup EXIT

cp -R "$APP" "$STAGE/"
ln -s /Applications "$STAGE/Applications"

mkdir -p "$STAGE/.background"
if [ -f "$ROOT/background.svg" ]; then
  qlmanage -t -s 1400 -o "$STAGE/.background" "$ROOT/background.svg" >/dev/null 2>&1 || true
  if [ -f "$STAGE/.background/background.svg.png" ]; then
    mv "$STAGE/.background/background.svg.png" "$STAGE/.background/background.png"
  fi
fi

hdiutil create -fs HFS+J -srcfolder "$STAGE" -volname "$VOLNAME" -format UDR -o "$DMG_TMP" >/dev/null

MOUNT=$(hdiutil attach "$DMG_TMP" -readwrite -noverify -noautoopen | awk -F'\t' '/\/Volumes\//{print $NF}')

osascript <<EOF
tell application "Finder"
  tell disk "$VOLNAME"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set the bounds of container window to {240, 160, 840, 560}
    set theViewOptions to the icon view options of container window
    set arrangement of theViewOptions to not arranged
    set icon size of theViewOptions to 128
    set label position of theViewOptions to bottom
    set background picture of theViewOptions to file ".background:background.png"
    set position of item "$APPNAME.app" of container window to {160, 280}
    set position of item "Applications" of container window to {440, 280}
    close
    open
    update without registering applications
    delay 1
  end tell
end tell
EOF

hdiutil detach "$MOUNT" -force >/dev/null
MOUNT=""

hdiutil convert "$DMG_TMP" -format UDZO -o "$OUT" >/dev/null

printf "wrote %s\n" "$OUT"