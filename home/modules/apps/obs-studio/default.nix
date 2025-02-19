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
      # FIXME: remove when https://github.com/NixOS/nixpkgs/pull/383402 is merged
      package = inputs.nixpkgs-obs-nvenc.legacyPackages.${pkgs.system}.obs-studio.override {
        cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
