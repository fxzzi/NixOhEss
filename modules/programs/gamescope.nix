{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cfg.programs.gamescope;
in {
  options.cfg.programs.gamescope.enable = lib.mkEnableOption "gamescope";

  config = lib.mkIf cfg.enable {
    hj.packages = with pkgs; [
      (gamescope.overrideAttrs {
        # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
        NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
      })
    ];
  };
}
