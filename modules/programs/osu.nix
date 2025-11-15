{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) callPackage;
  cfg = config.cfg.programs.osu;
  otd = config.cfg.services.opentabletdriver.enable;
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = callPackage "${pins.nix-gaming}/pkgs/osu-lazer-bin" {
    osu-mime = callPackage "${pins.nix-gaming}/pkgs/osu-mime" {};
    # allows for really low latency. if audio is glitching, increase
    pipewire_latency = "32/44100";
    # releaseStream = "tachyon";
    gmrun_enable = false;
    command_prefix = "env OSU_SDL3=1 SDL_VIDEO_DRIVER=x11";
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
