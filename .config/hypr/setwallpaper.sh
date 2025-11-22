#!/bin/sh
WALL_DIR="${HOME}/Pictures/wallpapers"

command -v swww >/dev/null 2>&1 || { printf 'swww not found\n' >&2; exit 1; }
[ -n "$WALL_DIR" ] || exit 0
[ -d "$WALL_DIR" ] || exit 0

# collect file list (one per line)
FILES=$(find -- "$WALL_DIR" -type f -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp')
[ -n "$FILES" ] || exit 0

#printf '%s\n' "$FILES"

PIC=$(printf '%s\n' "$FILES" | awk 'BEGIN{srand()} { if(rand() <= 1/NR) sel=$0 } END{print sel}')
[ -n "$PIC" ] || exit 0

if ! swww query >/dev/null 2>&1; then
  command -v swww-daemon >/dev/null 2>&1 && swww-daemon >/dev/null 2>&1 &
  sleep 0.5
fi

if swww query >/dev/null 2>&1; then
  swww img "$PIC" --transition-type random --transition-duration 3 --transition-fps 60 >/dev/null 2>&1 || true
fi
