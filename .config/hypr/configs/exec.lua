-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Quickshell provides the bar, quick settings and the notification daemon.
    -- It owns org.freedesktop.Notifications, so dunst must not also run.
    hl.exec_cmd("qs -c shell")

    hl.exec_cmd("hypridle")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start pipewire")
    hl.exec_cmd("systemctl --user start pipewire-pulse")
    hl.exec_cmd("systemctl --user start wireplumber")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("sleep 5 && blueman-applet")
    hl.exec_cmd("systemctl --user start hyprland-session.target")

    -- waybar stays until the Quickshell bar has fully replaced it (phase 6).
    hl.exec_cmd("waybar")

    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
