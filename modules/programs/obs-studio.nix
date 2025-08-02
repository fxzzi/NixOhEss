{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.programs.obs-studio.enable = lib.mkEnableOption "obs-studio";
  config = lib.mkIf config.cfg.programs.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
