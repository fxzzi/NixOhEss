{
  config,
  lib,
  ...
}: let
  inherit (builtins) toString;
  keepCount = toString config.boot.loader.systemd-boot.configurationLimit;
in {
  options.cfg.cli.nh.enable = lib.mkEnableOption "nh";
  config = lib.mkIf config.cfg.cli.nh.enable {
    programs.nh = {
      enable = true;
      flake = "${config.hj.xdg.configDirectory}/nixos";
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
