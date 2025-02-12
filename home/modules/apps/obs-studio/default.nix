{
  pkgs,
  lib,
  config,
  npins,
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
      plugins = with pkgs.obs-studio-plugins; [
        obs-vkcapture
        (obs-pipewire-audio-capture.overrideAttrs
          {
            pname = "obs-studio-plugins.obs-pipewire-audio-capture-git";
            version = "0-unstable";
            src = npins.obs-pipewire-audio-capture;
            cmakeFlags = [
              "-DCMAKE_INSTALL_LIBDIR=./lib"
              "-DCMAKE_INSTALL_DATADIR=./usr"
            ];
          })
      ];
    };
  };
}
