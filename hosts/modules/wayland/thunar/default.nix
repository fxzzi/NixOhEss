{
  lib,
  config,
  pkgs,
  ...
}: {
  options.wayland.thunar.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the thunar file manager and some plugins for it.";
  };
  config = lib.mkIf config.wayland.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ]; # Enable some plugins for archive support
    };

    programs.file-roller.enable = true; # Enable File Roller for GUI archive management
  };
}
