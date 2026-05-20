{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.obs-studio;
in {
  options.cfg.programs.obs-studio = {
    enable = mkEnableOption "obs-studio";
    vkcapture.enable = mkEnableOption "obs-vkcapture";
  };
  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        (mkIf cfg.vkcapture.enable obs-vkcapture)
        obs-pipewire-audio-capture
        inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.obs-wayland-hotkeys
      ];
    };
  };
}
