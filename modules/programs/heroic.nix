{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.heroic;
in
{
  options.cfg.programs.heroic.enable = mkEnableOption "heroic";
  config = mkIf cfg.enable {
    hj.packages = [ pkgs.heroic ];
  };
}
