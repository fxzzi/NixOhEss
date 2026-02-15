{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.gpu-screen-recorder;
in {
  options.cfg.programs.gpu-screen-recorder.enable = mkEnableOption "gpu-screen-recorder";
  config = mkIf cfg.enable {
    programs.gpu-screen-recorder = {
      enable = true;
    };
    hj = {
      packages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    };
  };
}
