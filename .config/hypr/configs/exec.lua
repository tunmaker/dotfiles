-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Quickshell provides the bar, quick settings, launcher and the
    -- notification daemon. It owns org.freedesktop.Notifications, so no other
    -- notification daemon may run alongside it.
    hl.exec_cmd("qs -c shell")

    hl.exec_cmd("hypridle")
    hl.exec_cmd("awww-daemon")

    -- Restore the last wallpaper, which also regenerates the palette.
    hl.exec_cmd("sleep 1 && ~/.config/hypr/setwallpaper.sh \"$(cat ~/.local/state/quickshell/wallpaper 2>/dev/null)\"")

    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start pipewire")
    hl.exec_cmd("systemctl --user start pipewire-pulse")
    hl.exec_cmd("systemctl --user start wireplumber")
    hl.exec_cmd("systemctl --user start hyprland-session.target")

    hl.exec_cmd("[workspace special:magic silent] keepassxc")

    -- kDrive ships no Wayland tray icon; xcb runs it through XWayland.
    hl.exec_cmd("QT_QPA_PLATFORM=xcb ~/.local/bin/kDrive-3.8.5.2-amd64.AppImage")

    -- nm-applet and blueman-applet are no longer started: the shell has its own
    -- network and bluetooth controls, and their tray icons only duplicated them.

    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
