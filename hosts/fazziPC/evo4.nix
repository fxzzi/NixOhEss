{
  config,
  pkgs,
  self,
  ...
}:
let
  alsa-ucm-conf' = pkgs.alsa-ucm-conf.overrideAttrs {
    patches = [
      # USB-Audio/EVO4: correct naming scheme for Master Playback
      (pkgs.fetchpatch {
        url = "https://github.com/alsa-project/alsa-ucm-conf/commit/cd50898a4956b26ec038b64a8286282d263a5885.patch";
        hash = "sha256-T/k/pXJ3hhYOaL9Wy4qaz1g4FEb+4VVW3DcVbTi5Nsc=";
      })
    ];
  };

  extraEnv.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
in
{
  config = {
    # save the EVO4 options in ALSA, including mic gain, phantom power, etc.
    hardware.alsa.enablePersistence = true;
    boot = {
      extraModulePackages = [
        # patched snd-usb-audio containing EVO4 mixer quirks
        # this lets ALSA expose all the hardware controls to the system
        # https://lore.kernel.org/lkml/20260919151840.24371-1-arc@gmx.li/
        # also fixes hardware volume control not working properly
        # https://lore.kernel.org/regressions/CANBVYRCL=8QdLxGg4S6qrahrFtwJxhv-aSGpW7-1S=+iOe4ZGA@mail.gmail.com/T/#u
        (config.boot.kernelPackages.callPackage "${self}/pkgs/snd-usb-audio/package.nix" { })
      ];
    };
    systemd.user.services = {
      pipewire.environment = extraEnv;
      wireplumber.environment = extraEnv;
    };
  };
}
