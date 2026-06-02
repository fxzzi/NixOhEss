{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.programs.codium;
in {
  options.cfg.programs.codium = {
    enable = mkEnableOption "vscodium";
    defaultEditor = mkEnableOption "Use vscodium as the default editor";
  };

  config = mkIf cfg.enable {
    hj.packages = [
      (pkgs.vscodium.override {
        commandLineArgs = config.cfg.programs.chromium.commonArgs;
      }).fhs
    ];
    environment.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = mkForce "codium";
    };
    xdg.mime = {
      # mkForce to override nvim being the default (for noobs)
      defaultApplications = mkIf cfg.defaultEditor {
        "text/*" = mkForce "codium.desktop";
      };
      removedAssociations = {
        "inode/directory" = "codium.desktop";
      };
      addedAssociations = {
        "text/*" = ["codium.desktop"];
      };
    };
  };
}
