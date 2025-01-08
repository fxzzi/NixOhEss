{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.music.extraApps.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables some extra music related apps";
  };
  config = lib.mkIf config.music.extraApps.enable {
    home.packages = with pkgs; [
      nicotine-plus
      picard
    ];
  };
  imports = [
    ./mpd
    ./ncmpcpp
  ];
}
