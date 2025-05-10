{
  config,
  lib,
  ...
}: {
  options.cfg.cli.nh.enable = lib.mkEnableOption "nh";
  config = lib.mkIf config.cfg.cli.nh.enable {
    programs.nh = {
      enable = true;
      flake = "${config.hj.xdg.configDirectory}/nixos";
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
