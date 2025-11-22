{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatStringsSep;
  inherit (pkgs) callPackage;
  cfg = config.cfg.programs.osu;
  otd = config.cfg.services.opentabletdriver.enable;
  envVars = [
    "OSU_SDL3=1"
    "SDL_VIDEO_DRIVER=wayland"
    ''PIPEWIRE_ALSA="{ alsa.buffer-bytes=640 alsa.period-bytes=128 }"''
  ];
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = callPackage "${pins.nix-gaming}/pkgs/osu-lazer-bin" {
    osu-mime = callPackage "${pins.nix-gaming}/pkgs/osu-mime" {};
    # allows for really low latency. if audio is glitching, increase
    pipewire_latency = "32/44100";
    command_prefix = "env ${concatStringsSep " " envVars}";
  };
in {
  options.cfg.programs.osu.enable = mkEnableOption "osu!";

  config = mkIf cfg.enable {
    environment.systemPackages = [osu];

    # if otd is disabled, still allow the osu internal tablet driver to work.
    services.udev.packages =
      mkIf (!otd)
      [pkgs.opentabletdriver];
    boot.blacklistedKernelModules =
      mkIf (!otd)
      config.hardware.opentabletdriver.blacklistedKernelModules;
  };
}
