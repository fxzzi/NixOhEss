{
  lib,
  config,
  ...
}: let
  cfg = config.programs.hyprland;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      # run electron, gtk, qt apps in wayland native
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";

      # fix java bug on tiling wm's / compositors
      _JAVA_AWT_WM_NONREPARENTING = "1";
      # enable java anti aliasing
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";

      # don't use libdecor as it's a little borken
      LIBDECOR_PLUGIN_DIR = "nope";
    };
  };
}
