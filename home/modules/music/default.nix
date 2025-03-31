{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.music.extraApps.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables some extra music related apps";
  };
  config = lib.mkIf config.cfg.music.extraApps.enable {
    home.packages = with pkgs; [
      nicotine-plus
      picard
      rsgain
    ];
  };
  imports = [
    ./mpd
    ./ncmpcpp
  ];
}
