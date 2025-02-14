{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.apps.obs-studio.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables OBS studio with a few plugins";
  };
  config = lib.mkIf config.apps.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-vkcapture
        inputs.nixpkgs-master.legacyPackages.${pkgs.system}.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}
