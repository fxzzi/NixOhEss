{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.gamescope;
in
{
  options.cfg.programs.gamescope.enable = mkEnableOption "gamescope";

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
    };
  };
}
