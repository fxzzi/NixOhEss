-- layer rules
hl.layer_rule({ match = { namespace = "launcher" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "power-menu" }, blur = true, xray = true, ignore_alpha = 0, dim_around = true })
hl.layer_rule({ match = { namespace = "wall-picker" }, blur = true, xray = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "bar-.*" }, blur = true, xray = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, animation = "slide" })
-- show `still` below `slurp`, but above notifications
-- used to freeze screen during selection screenshots
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true, order = -2 })
hl.layer_rule({ match = { namespace = "still" }, no_anim = true, order = -1 })

-- hyprland shows anr dialog when stremio is in another workspace, so render_unfocused 1
hl.window_rule({ match = { class = ".*stremio.*" }, render_unfocused = true, content = "video" })
-- no vrr on video content, like mpv
hl.window_rule({ match = { content = "video" }, idle_inhibit = "fullscreen", no_vrr = true })

hl.window_rule({ match = { class = "atril" }, idle_inhibit = "focus" })

-- oled flicker is annoying on some apps
hl.window_rule({ match = { class = "dev.notashelf.beer" }, idle_inhibit = "fullscreen", no_vrr = true })
hl.window_rule({ match = { class = "org.gnome.Loupe" }, no_vrr = true })

-- ignore maximize requests from apps. You'll probably like this.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- dialogs
hl.window_rule({ match = { title = "File Operation Progress.*" }, float = true })
hl.window_rule({ match = { title = "Confirm to replace files.*" }, float = true })
hl.window_rule({ match = { title = "Select a File.*" }, float = true })
hl.window_rule({ match = { title = "Save As.*" }, float = true })
hl.window_rule({ match = { title = "Rename.*" }, float = true })
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true })
hl.window_rule({ match = { class = "org.gnome.FileRoller", title = "Extract.*" }, float = true })

-- apply to everything
hl.window_rule({
	match = { class = ".*" },
	-- thank god this can be disabled
	no_xdg_drags = true,
})

-- disable blur for slow apps
hl.window_rule({ match = { class = "steam" }, no_blur = true })
hl.window_rule({ match = { class = "discord" }, no_blur = true })
