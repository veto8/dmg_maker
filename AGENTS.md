# AGENTS.md — dmg_maker

## What this is

Example project that builds a **drag-to-install DMG** (app icon + arrow to an
`Applications` shortcut over a background image) for macOS.

## Stack

- POSIX shell (`make_dmg.sh`, `ask.sh`)
- macOS tools: `hdiutil` (create/attach/convert DMG), `qlmanage` (SVG → PNG),
  Finder + AppleScript (`osascript`) for the window layout
- No compile step; the build runs on macOS only

## Run

`./ask.sh` shows the menu; the user runs it, the agent never does.

| ID | Task |
|----|------|
| 1 | Setup - check requirements (`hdiutil`, `qlmanage`, `osascript`) |
| 2 | Build `dist/Example.dmg` from `App/Example.app` |
| 3 | Clean `.build/` and `dist/` |

`make_dmg.sh [app] [out]` can also be run directly. Optional env `VOLNAME`
(default `Example`).

## Structure

- `make_dmg.sh` — create image, mount, set Finder layout via AppleScript, convert
- `background.svg` — window background, rasterized by `qlmanage`
- `App/Example.app` — sample app bundle (`Contents/Info.plist` + `MacOS/Example`)
- `ask.sh` — task switch
- `ask.d/` — task scripts (`setup.sh`, `build.sh`, `clean.sh`)

## Conventions

- No comments in code unless asked.
- macOS-only: `hdiutil`, `qlmanage`, Finder. Does not run on Linux.
- The agent never builds; the user runs `./ask.sh` / `make_dmg.sh` on a Mac.