<img src="dmg_maker.svg" alt="dmg_maker logo" width="120">

# dmg_maker

Example of a **drag-to-install DMG** — the window that shows the app icon and an
arrow pointing at an `Applications` shortcut over a background image.

## How it works

A DMG is a mounted HFS+ disk image. This project builds one that contains:

- the `.app` bundle (`App/Example.app`)
- a symlink `Applications -> /Applications`
- a `.background/background.png` image

`make_dmg.sh` creates the image with `hdiutil`, mounts it, then uses a small
AppleScript to tell **Finder** to draw the icon-view window: hide the toolbar and
status bar, set the window bounds, set the background picture, and position the
app and the `Applications` shortcut. Finder stores that layout in the volume's
`.DS_Store`; the finished image is converted to a compressed `UDZO` DMG.

Nothing custom runs at install time — Finder does the copy when the user drags
the app onto the `Applications` symlink.

## Build (on macOS)

```sh
./ask.sh          # task 1 builds dist/Example.dmg
# or directly:
./make_dmg.sh [App/Example.app] [dist/Example.dmg]
```

Requires macOS with `hdiutil`, `qlmanage`, and Finder (AppleScript). It will not
run on Linux.

## Layout

- `make_dmg.sh` — builds the drag-to-install DMG
- `background.svg` — window background (rasterized to PNG via `qlmanage`)
- `App/Example.app` — sample app to package
- `ask.sh` — task runner (build / clean)