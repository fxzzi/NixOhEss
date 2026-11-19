-- run electron, gtk, qt apps in wayland native
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- enable java anti aliasing
hl.env("_JAVA_OPTIONS", "-Dawt.useSystemAAFontSettings=on")

-- don't use libdecor as it's a little borken
hl.env("LIBDECOR_PLUGIN_DIR", "nope")
