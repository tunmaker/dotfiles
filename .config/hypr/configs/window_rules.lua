-- Converted from configs/window_rules.conf
-- NOTE: this file was never sourced by the old hyprland.conf either.
--       Uncomment the require in hyprland.lua to enable it.

hl.window_rule({ match = { class = "Minecraft.*" }, size = { 1920, 1080 } })
hl.window_rule({ match = { class = "DOOM.*" },     size = { 1920, 1080 } })

hl.window_rule({ match = { class = "kcalc" },                  float = true })
hl.window_rule({ match = { class = "zoom" },                   float = true })
hl.window_rule({ match = { class = "Plexamp" },                float = true })
hl.window_rule({ match = { class = "Rofi" },                   float = true })
hl.window_rule({ match = { class = "inkstitch" },              float = true })
hl.window_rule({ match = { class = "pavucontrol-qt" },        float = true })
hl.window_rule({ match = { class = "lxqt-policykit-agent" },   float = true })
hl.window_rule({ match = { title = "^(Welcome to Audacity\\!)$" }, float = true })
hl.window_rule({ match = { title = "^(Wine System Tray)$" },       float = true })
hl.window_rule({ match = { title = "Break Apart Fill Objects" },   float = true })

hl.window_rule({ match = { class = "Plexamp" },              size = { 400, 600 } })
hl.window_rule({ match = { title = "ripdrag" },              size = { 600, 360 } })
hl.window_rule({ match = { class = "Plexamp" },              move = { 1518, 478 } })
hl.window_rule({ match = { title = "^(Wine System Tray)$" }, move = { 1518, 478 } })
hl.window_rule({ match = { class = "^(bethesda.net_launcher.exe)$" }, move = { 320, 140 } })
-- hl.window_rule({ match = { class = "^(bethesda.net_launcher.exe)$" }, fullscreen = true })

hl.window_rule({ match = { class = "ffxiv.*" },  no_blur = true })
hl.window_rule({ match = { class = "xsnow" },    no_blur = true })
hl.window_rule({ match = { class = "xsnow" },    pin = true })
hl.window_rule({ match = { class = "gamescope" }, no_blur = true })
hl.window_rule({ match = { class = "gamescope" }, fullscreen = true })
-- hl.window_rule({ match = { class = "^(gamescope)$" }, workspace = "6 silent" })
hl.window_rule({ match = { class = "explorer.exe" }, fullscreen = true })

hl.window_rule({ match = { title = "^(Picture in picture)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture in picture)$" }, pin = true })

hl.window_rule({ match = { class = "REAPER", title = "menu" }, allows_input = true })
hl.window_rule({ match = { title = "REDlauncher" },            allows_input = true })

hl.window_rule({ match = { title = "^(Spotify)$" }, workspace = "5 silent" })
hl.window_rule({ match = { title = "^(Spotify)$" }, tile = true })
hl.window_rule({ match = { title = "^(Wine System Tray)$" }, workspace = "special silent" })

-- Rhythm Doctor
hl.window_rule({ match = { title = "^(Rhythm Doctor)$" }, allows_input = true })

-- Shimeji mascot
hl.window_rule({
    match       = { class = "com-group_finity-mascot-Main" },
    float       = true,
    no_blur     = true,
    no_focus    = true,
    no_shadow   = true,
    border_size = 0,
})

hl.window_rule({
    match       = { class = "^(steam_app_1920960)$", title = "^(MainWindow)$" },
    float       = true,
    no_anim     = true,
    no_blur     = true,
    no_shadow   = true,
    border_size = 0,
    pin         = true,
})

hl.window_rule({ match = { class = "^(REAPER)$", title = "^(menu)$" }, no_anim = true })
hl.window_rule({ match = { class = "^(REAPER)$", title = "^(menu)$" }, move = { 0, 0 } })
