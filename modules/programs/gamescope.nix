{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.gamescope;
in {
  options.cfg.programs.gamescope.enable = mkEnableOption "gamescope";

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope.overrideAttrs {
        # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
        NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
      };
    };
  };
}
