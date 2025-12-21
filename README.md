# minimal dotfiles
simply keeping trask of my dotfiles and packages

## install
`pacman -S hyprland hypridle hyprlock waybar swww kate kitty dolphin rofi dunst hyprpolkitagent networkmanager nm-connection-editor network-manager-applet  blueman pipewire pipewire-pulse wireplumber pavucontrol-qt firefox vlc vlc-plugin-ffmpeg archlinux-xdg-menu`

## others
- fonts `ttf-nerd-fonts-symbols`
- mount android devices `kio-extras`
- mount usb devices `udisks2 udiskie`
- `keepassxc`
- 
## AUR
- [Hardinfo2](https://aur.archlinux.org/packages/hardinfo2)
- [qview](https://aur.archlinux.org/qview.git)

## inspired from:
- https://github.com/sameemul-haque/dotfiles/tree/master
- https://github.com/ericmurphyxyz/dotfiles/tree/master

## kdenlive GPU rendering
- Install drivers/tools:
    `sudo pacman -Syu intel-media-driver libva-utils libva ffmpeg`

- Ensure user in video group:
    `sudo usermod -aG video $USER`
    `newgrp video`

- Verify VAAPI and driver:
    `vainfo`

##Screenshots:
source https://knng.de/blog/hyprland_screenshots/
we need :
    - grim - Screenshot utility for Wayland
    - slurp - Select a region in a Wayland compositor
    - wl-clipboard - Command-line copy/paste utilities for Wayland

`sudo pacman -S grim slurp wl-clipboard`

and in keybinds we have :
`bind = , PRINT, exec, grim -g "$(slurp)" - | wl-copy`
