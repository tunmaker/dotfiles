#!/bin/sh
# Picks a wallpaper, sets it, and regenerates the colour scheme from it.
# Pass a path to use a specific image instead of a random one.
WALL_DIR="${HOME}/Pictures/wallpapers"

command -v awww >/dev/null 2>&1 || { printf 'awww not found\n' >&2; exit 1; }

if [ -n "$1" ]; then
  [ -f "$1" ] || { printf 'no such file: %s\n' "$1" >&2; exit 1; }
  PIC="$1"
else
  [ -d "$WALL_DIR" ] || exit 0
  # -o binds looser than the implicit -a, so the -name tests need grouping;
  # without it the jpg branch ignored -type f.
  FILES=$(find -- "$WALL_DIR" -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' \))
  [ -n "$FILES" ] || exit 0
  PIC=$(printf '%s\n' "$FILES" | awk 'BEGIN{srand()} { if(rand() <= 1/NR) sel=$0 } END{print sel}')
fi
[ -n "$PIC" ] || exit 0

if ! awww query >/dev/null 2>&1; then
  command -v awww-daemon >/dev/null 2>&1 && awww-daemon >/dev/null 2>&1 &
  sleep 0.5
fi

if awww query >/dev/null 2>&1; then
  awww img "$PIC" --transition-type random --transition-step 90 --transition-fps 60 >/dev/null 2>&1 || true
fi

# Regenerate the palette. --prefer is required when an image yields several
# candidate source colours and there is no terminal available to ask.
# Quickshell watches the generated file and restyles itself live.
if command -v matugen >/dev/null 2>&1; then
  matugen image "$PIC" --prefer saturation >/dev/null 2>&1 || true
fi

# Remember the choice so it can be restored at login.
mkdir -p "${HOME}/.local/state/quickshell"
printf '%s\n' "$PIC" > "${HOME}/.local/state/quickshell/wallpaper"
