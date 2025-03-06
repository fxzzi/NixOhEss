{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.wayland.thunar.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the thunar file manager and some plugins for it.";
  };
  config = lib.mkIf config.cfg.wayland.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ]; # Enable some plugins for archive support
    };
    services = {
      tumbler.enable = true; # Thunar thumbnailer
      gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
      gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
    };
    programs.file-roller.enable = true; # Enable File Roller for GUI archive management
  };
}
