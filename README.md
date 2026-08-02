# minimal dotfiles

simply keeping track of my dotfiles and packages.

Hyprland 0.55+ with the Lua config (`.config/hypr/*.lua` — the old hyprlang
`.conf` files are kept for reference only), plus a custom desktop shell built
on [Quickshell](https://quickshell.outfoxxed.me/) that replaces waybar, rofi,
dunst, nm-applet and blueman-applet.

## install

Core:

`pacman -S hyprland hypridle hyprlock hyprpolkitagent quickshell matugen brightnessctl power-profiles-daemon networkmanager pipewire pipewire-pulse wireplumber kitty dolphin kate firefox vlc vlc-plugin-ffmpeg archlinux-xdg-menu`

Everything comes from the official repos — the shell deliberately needs no AUR
packages, no npm/pip, and no extra groups (`input`/`i2c` are intentionally not
used).

Optional GUIs (not autostarted; the shell has its own network/bluetooth/audio
controls): `nm-connection-editor blueman pavucontrol-qt`

`systemctl enable --now power-profiles-daemon` for the power-profile toggle.

## shell (quickshell)

Config in `.config/quickshell/shell`, started from Hyprland autostart as
`qs -c shell`. Provides:

- top bar: workspaces, clock, system stats (net traffic, cpu, temp, ram), tray, status icons
- quick settings panel: bluetooth / wi-fi / power-profile / mute toggles with
  expandable device pickers, volume + brightness sliders, media player card,
  notification history, session buttons
- notification daemon (owns `org.freedesktop.Notifications` — do not run dunst
  or mako alongside)
- app launcher (fuzzy search)
- wallpaper theming: `setwallpaper.sh` picks a wallpaper (awww), runs matugen,
  and the shell restyles itself live from
  `~/.local/state/quickshell/colors.json`

Keybinds (see `.config/hypr/configs/keybinds.lua`):

| key | action |
|---|---|
| `SUPER+R` | launcher |
| `SUPER+N` | quick settings |
| `SUPER+SHIFT+N` | clear notifications |
| `SUPER+W` | random wallpaper + retheme |

IPC from scripts: `qs -c shell ipc call panel toggle`, `... panel launcher`,
`... notifications clear`.

## others

- fonts `ttf-nerd-fonts-symbols` (shell icons), `adwaita-fonts` (shell UI)
- mount android devices `kio-extras`
- mount usb devices `udisks2 udiskie`
- `keepassxc`

## shell prompt (starship)

Powerline "bubble" prompt, multiline, Catppuccin Mocha.

Install (the Nerd Font is required for the separators/icons):

`sudo pacman -S starship ttf-jetbrains-mono-nerd`

Set the terminal font to `JetBrainsMono Nerd Font`, then hook starship into
bash by adding this line to `~/.bashrc` and restarting the shell:

```bash
eval "$(starship init bash)"
```

The config is tracked in this repo at `.config/starship.toml` (hardlink it to
`~/.config/starship.toml`).

## AUR

- [Hardinfo2](https://aur.archlinux.org/packages/hardinfo2)
- [qview](https://aur.archlinux.org/qview.git)
- [awww](https://archlinux.org/packages/extra/x86_64/awww/) instead of swww

follow this gist for [screen sharing](https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580)

## inspired from:

- https://github.com/sameemul-haque/dotfiles/tree/master
- https://github.com/ericmurphyxyz/dotfiles/tree/master
- layout ideas from https://github.com/end-4/dots-hyprland (shell written from
  scratch against the Quickshell 0.3 API)

## kdenlive GPU rendering

- Install drivers/tools:
    `sudo pacman -Syu intel-media-driver libva-utils libva ffmpeg`

- Ensure user in video group:
    `sudo usermod -aG video $USER`
    `newgrp video`

- Verify VAAPI and driver:
    `vainfo`

## screenshots

source https://knng.de/blog/hyprland_screenshots/

`sudo pacman -S grim slurp wl-clipboard`

Bound to `PRINT` in `.config/hypr/configs/keybinds.lua`:

```lua
hl.bind("PRINT", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
```
