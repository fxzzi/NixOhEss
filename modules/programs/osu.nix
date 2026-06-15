{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatStringsSep optionalString;
  cfg = config.cfg.programs.osu;
  otd = config.cfg.services.opentabletdriver.enable;
  envVars = [
    "OSU_SDL3=1"
    "PIPEWIRE_ALSA=\"{ alsa.buffer-bytes=512 alsa.period-bytes=64 }\""
  ];
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
    # lower audio latency
    pipewire_latency = "32/44100";
    command_prefix = "env ${concatStringsSep " " envVars} ${optionalString config.cfg.programs.mangohud.enable "mangohud"}";
  };
in {
  options.cfg.programs.osu.enable = mkEnableOption "osu!";

  config = mkIf cfg.enable {
    environment.systemPackages = [osu];

    # if otd is disabled, still allow the osu internal tablet driver to work.
    services.udev.packages = mkIf (!otd) [pkgs.opentabletdriver];
    boot.blacklistedKernelModules = mkIf (!otd) config.hardware.opentabletdriver.blacklistedKernelModules;
  };
}
