{
  config,
  pkgs,
  lib,
  ...
}: let
  alsa-ucm-conf' = pkgs.alsa-ucm-conf.overrideAttrs {
    src = pkgs.fetchurl {
      url = "mirror://alsa/lib/alsa-ucm-conf-1.2.16.tar.bz2";
      hash = "sha256-rLyXLW5x7fo0Xnav3xDDmf0PHzz5DYSv20z1G/xKZUg=";
    };
    version = "1.2.16";
    patches = [];
  };
  systemWide = config.services.pipewire.systemWide;
  extraEnv.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
in {
  config = {
    # FIXME: bump alsa-ucm-conf to get the EVO4 profile.
    # remove when https://github.com/NixOS/nixpkgs/pull/527444 is in unstable
    environment.variables = {
      ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
    };
    systemd.services = lib.mkIf systemWide {
      pipewire.environment = extraEnv;
      wireplumber.environment = extraEnv;
    };
    systemd.user.services = lib.mkIf (!systemWide) {
      pipewire.environment = extraEnv;
      wireplumber.environment = extraEnv;
    };

    hardware.audient-evo.config = {
      monitor = 50;
      input1 = {
        gain = 40;
        phantom = true;
        mute = false;
      };
      output.mute = false;
    };
  };
}
