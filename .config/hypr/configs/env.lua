-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Cursor theming
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("TERM", "xterm-256color")

-- Graphics driver selection
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")

-- Intel gpu
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "0")
hl.env("WLR_DRM_DEVICES", "/dev/dri/card1")
hl.env("VK_ICD_FILENAMES", "/usr/share/vulkan/icd.d/intel_icd.x86_64.json")
hl.env("DXVK_HUD", "devinfo,stats")

-- Hardware acceleration
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Qt applications
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Java applications
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Input methods
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

hl.env("EDITOR", "vim")
hl.env("OLLAMA_MODELS", "/mnt/nvme2/models/ollama/")

-- Third argument = true exports to the systemd / dbus activation environment (old `envd`)
hl.env("WAYLAND_DISPLAY", "wayland-1", true)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland", true)
hl.env("XDG_SESSION_TYPE", "wayland", true)
hl.env("XDG_MENU_PREFIX", "arch-", true)
