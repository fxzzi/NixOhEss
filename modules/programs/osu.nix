{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) callPackage;
  cfg = config.cfg.programs.osu;
  otd = config.cfg.services.opentabletdriver.enable;
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = callPackage "${npins.nix-gaming}/pkgs/osu-lazer-bin" {
    osu-mime = callPackage "${npins.nix-gaming}/pkgs/osu-mime" {};
    # 64 quantum is pretty low. My PC can handle it through my IEMs,
    # but not my speakers. Provides theoretical latency of 1.46ms.
    pipewire_latency = "64/44100";
    gmrun_enable = false;
    # HACK: adding env vars like so needs `env` as you can't add
    # env vars after an `exec` command.
    command_prefix = "env OSU_SDL3=1";
    # releaseStream = "tachyon";
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
