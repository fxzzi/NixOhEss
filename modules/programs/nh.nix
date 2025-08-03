{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) toString;
  cfg = config.cfg.programs.nh;
  keepCount = toString config.boot.loader.systemd-boot.configurationLimit;
in {
  options.cfg.programs.nh.enable = mkEnableOption "nh";
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${config.cfg.core.username}/.config/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        # it only needs to keep what can be shown in the bootloader
        extraArgs = "--keep ${keepCount}";
      };
    };

    environment.shellAliases = {
      # rb means rebuild
      rb = "nh os switch";
      rbu = "nh os switch -u";
      rbb = "nh os boot";
      rbbu = "nh os boot -u";
    };
  };
}
