{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.cfg.programs.obs-studio;
in {
  options.cfg.programs.obs-studio.enable = lib.mkEnableOption "obs-studio";
  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
