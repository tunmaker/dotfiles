#!/usr/bin/env python3
# Waybar custom media script (works well with VLC + playerctl)
# Outputs a single JSON object: {"text": "...", "icon": "...", "tooltip": "..."}

import sys, json, shlex, subprocess

MAX_LEN = 40

def run(cmd):
    try:
        return subprocess.check_output(shlex.split(cmd), stderr=subprocess.DEVNULL).decode().strip()
    except subprocess.CalledProcessError:
        return ""
    except Exception:
        return ""

def list_players():
    out = run("playerctl -l")
    return out.splitlines() if out else []

def choose_player(prefer="vlc"):
    players = list_players()
    if not players:
        return ""
    for p in players:
        if prefer in p.lower():
            return p
    return players[0]

def status(player):
    return run(f"playerctl -p {player} status").lower()

def metadata(player, key):
    return run(f"playerctl -p {player} metadata {key}")

def position(player):
    return run(f"playerctl -p {player} position")

def safe_trunc(s, n):
    return (s[:n-1] + "…") if len(s) > n else s

def fmt_time_seconds(s):
    try:
        sec = int(float(s))
        m = sec // 60
        ss = sec % 60
        return f"{m:02d}:{ss:02d}"
    except Exception:
        return ""

def build_output(icon, text):
    payload = {"text": text, "icon": icon, "tooltip": text}
    print(json.dumps(payload))
    sys.stdout.flush()

def main():
    player = choose_player()
    if not player:
        build_output("🎜", "Stopped")
        return

    st = status(player)
    if st not in ("playing", "paused"):
        build_output("🎜", "Stopped")
        return

    # Try multiple possible metadata keys for artist/title
    artist = metadata(player, "xesam:artist") or metadata(player, "xesam:artist[0]") or ""
    title  = metadata(player, "xesam:title") or metadata(player, "xesam:track") or ""
    album  = metadata(player, "xesam:album") or ""
    length_us = metadata(player, "mpris:length")
    pos = position(player)

    total = ""
    if length_us:
        try:
            total = fmt_time_seconds(int(int(length_us) / 1_000_000))
        except Exception:
            total = ""

    elapsed = fmt_time_seconds(pos) if pos else ""

    # Build display text: prefer "artist - title (mm:ss/TT:TT)" or fallback to title/filename
    parts = []
    if artist:
        parts.append(artist)
    if title:
        parts.append(title)
    if album and not title:
        parts.append(album)

    core = " - ".join(parts) if parts else (title or artist or "Unknown")
    core = safe_trunc(core, MAX_LEN)
    if total:
        core = f"{core} ({elapsed}/{total})"

    icon = "" if st == "playing" else ""
    build_output(icon, core)

if __name__ == "__main__":
    main()
