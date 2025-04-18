{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.apps.obs-studio.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables OBS studio with a few plugins";
  };
  config = lib.mkIf config.cfg.apps.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
