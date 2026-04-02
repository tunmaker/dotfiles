#!/bin/sh
WALL_DIR="${HOME}/Pictures/wallpapers"
command -v awww >/dev/null 2>&1 || { printf 'awww not found\n' >&2; exit 1; }
[ -n "$WALL_DIR" ] || exit 0
[ -d "$WALL_DIR" ] || exit 0
# collect file list (one per line)
FILES=$(find -- "$WALL_DIR" -type f -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp')
[ -n "$FILES" ] || exit 0
#printf '%s\n' "$FILES"
PIC=$(printf '%s\n' "$FILES" | awk 'BEGIN{srand()} { if(rand() <= 1/NR) sel=$0 } END{print sel}')
[ -n "$PIC" ] || exit 0
if ! awww query >/dev/null 2>&1; then
  command -v awww-daemon >/dev/null 2>&1 && awww-daemon >/dev/null 2>&1 &
  sleep 0.5
fi
if awww query >/dev/null 2>&1; then
  awww img "$PIC" --transition-type random --transition-step 90 --transition-fps 60 >/dev/null 2>&1 || true
fi