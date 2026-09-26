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
    boot = {
      extraModulePackages = [
        # patched snd-usb-audio containing EVO4 mixer quirks
        # this lets ALSA expose all the hardware controls to the system
        # https://lore.kernel.org/lkml/20260919151840.24371-1-arc@gmx.li/
        (config.boot.kernelPackages.callPackage "${self}/pkgs/snd-usb-audio/package.nix" { })
      ];
      # ignore errors from the USB controller for the EVO4.
      # a kernel regression in 7.2 somewhere causes pipewire to fail
      # to set the hardware volume, this fixes it.
      extraModprobeConfig = ''
        options snd_usb_audio quirk_flags=2708:0006:ignore_ctl_error
      '';
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
