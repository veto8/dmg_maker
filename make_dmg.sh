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

BUILD=$(mktemp -d "${TMPDIR:-/tmp}/dmg_maker.XXXXXX")
mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"

STAGE="$BUILD/src"
DMG_RW="$BUILD/tmp_rw.dmg"
MOUNT=""

cleanup() {
  [ -n "$MOUNT" ] && hdiutil detach "$MOUNT" -force >/dev/null 2>&1 || true
  rm -rf "$BUILD"
}
trap cleanup EXIT

mkdir -p "$STAGE"
cp -R "$APP" "$STAGE/"
ln -s /Applications "$STAGE/Applications"

mkdir -p "$STAGE/.background"
if [ -f "$ROOT/background_adium.png" ]; then
  cp "$ROOT/background_adium.png" "$STAGE/.background/background.png"
elif [ -f "$ROOT/background.png" ]; then
  cp "$ROOT/background.png" "$STAGE/.background/background.png"
elif [ -f "$ROOT/background.svg" ]; then
  qlmanage -t -s 460 -o "$STAGE/.background" "$ROOT/background.svg" >/dev/null 2>&1 || true
  if [ -f "$STAGE/.background/background.svg.png" ]; then
    mv "$STAGE/.background/background.svg.png" "$STAGE/.background/background.png"
  fi
fi

SIZE_MB=$(du -sm "$STAGE" | awk '{print $1}')
SIZE_MB=$((SIZE_MB + 32))

hdiutil create -size "${SIZE_MB}m" -fs HFS+J -volname "$VOLNAME" "$DMG_RW" >/dev/null

MOUNT=$(hdiutil attach "$DMG_RW" -readwrite -noverify -noautoopen | awk -F'\t' '/\/Volumes\//{print $NF}')
cp -Rp "$STAGE"/. "$MOUNT"/

osascript <<EOF
tell application "Finder"
  tell disk "$VOLNAME"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set the bounds of container window to {200, 120, 800, 520}
    set theViewOptions to the icon view options of container window
    set arrangement of theViewOptions to not arranged
    set icon size of theViewOptions to 96
    set label position of theViewOptions to bottom
    set background picture of theViewOptions to file ".background:background.png"
    set position of item "$APPNAME.app" of container window to {160, 245}
    set position of item "Applications" of container window to {440, 245}
    close
    open
    update without registering applications
    delay 1
  end tell
end tell
EOF

hdiutil detach "$MOUNT" -force >/dev/null
MOUNT=""

hdiutil convert "$DMG_RW" -format UDZO -o "$OUT" >/dev/null

printf "wrote %s\n" "$OUT"
