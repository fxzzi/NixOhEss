{
  pkgs,
  lib,
  config,
  inputs,
  osConfig,
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
      # FIXME: remove when https://github.com/NixOS/nixpkgs/pull/383402 is in nixos-unstable
      package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.obs-studio.override {
        inherit (osConfig.nixpkgs.config) cudaSupport;
      };
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
