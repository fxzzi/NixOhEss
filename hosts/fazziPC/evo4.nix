{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  alsa-ucm-conf' = pkgs.runCommand "audient-evo4-ucm-conf" { } ''
    cp -r --no-preserve=all ${pkgs.alsa-ucm-conf} $out

    # the mixer control name was fixed by one of the patches.
    # correct it in alsa-ucm-conf too.
    substituteInPlace \
      $out/share/alsa/ucm2/USB-Audio/Audient/Audient-EVO4-HiFi-0006.conf \
      --replace-fail \
        'PlaybackVolume "EVO4 "' \
        'PlaybackVolume "Master Playback Volume"
          PlaybackSwitch "Master Playback Switch"'
  '';

  systemWide = config.services.pipewire.systemWide;
  extraEnv.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf'}/share/alsa/ucm2";
in
{
  config = {
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

    systemd = {
      services = {
        pipewire.environment = lib.mkIf systemWide extraEnv;
        wireplumber.environment = lib.mkIf systemWide extraEnv;
      };
      user.services = {
        pipewire.environment = lib.mkIf (!systemWide) extraEnv;
        wireplumber.environment = lib.mkIf (!systemWide) extraEnv;
      };
    };
  };
}
