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
        (config.boot.kernelPackages.callPackage "${self}/pkgs/snd-usb-audio/package.nix" { })
      ];
      kernelModules = [ "snd-usb-audio" ];
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
