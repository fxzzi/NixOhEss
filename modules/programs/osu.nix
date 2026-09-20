{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    concatStringsSep
    optional
    ;
  cfg = config.cfg.programs.osu;
  otd = config.hardware.opentabletdriver;
  envVars = [
    "OSU_SDL3=1"
    "PIPEWIRE_ALSA=\"{ alsa.buffer-bytes=768 alsa.period-bytes=128 }\""
  ];
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
    # lower audio latency
    pipewire_latency = "32/44100";
    command_prefix = concatStringsSep " " (
      [ "env" ]
      ++ envVars
      ++ optional config.cfg.programs.mangohud.enable "mangohud"
      ++ optional config.cfg.programs.obs-studio.enable "obs-gamecapture"
    );
  };
in
{
  options.cfg.programs.osu.enable = mkEnableOption "osu!";

  config = mkIf cfg.enable {
    environment.systemPackages = [ osu ];

    # if otd is disabled, still allow the osu internal tablet driver to work.
    services.udev.packages = mkIf (!otd.enable) [ otd.package ];
    boot.blacklistedKernelModules = mkIf (!otd.enable) otd.blacklistedKernelModules;
  };
}
