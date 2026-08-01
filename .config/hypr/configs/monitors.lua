-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Multi-monitor layout, kept for reference. Monitor descriptors are hardware
-- identifiers, so they are not committed to this public repo — run
-- `hyprctl monitors` and substitute the real `desc:` strings locally.
--
-- hl.monitor({ output = "desc:<laptop panel>",  mode = "preferred",      position = "0x0",       scale = 1 })
-- hl.monitor({ output = "desc:<ultrawide>",     mode = "preferred",      position = "1920x0",    scale = 1 })
-- hl.monitor({ output = "desc:<side monitor>",  mode = "1600x900",       position = "4480x180",  scale = 1 })
-- hl.monitor({ output = "desc:<tv>",            mode = "1920x1080@120",  position = "0x-1080",   scale = 1, bitdepth = 10 })
--
-- hl.workspace_rule({ workspace = 1, monitor = "desc:<laptop panel>", default = true })
-- hl.workspace_rule({ workspace = 2, monitor = "desc:<ultrawide>",    default = true })
-- hl.workspace_rule({ workspace = 7, monitor = "desc:<side monitor>", default = true })
-- hl.workspace_rule({ workspace = 6, monitor = "desc:<tv>",           default = true })
