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
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
    releaseStream = "tachyon";
    command_prefix = concatStringsSep " " (
      [
        "env --unset=PIPEWIRE_LATENCY"

        # uses sdl2 by default
        "OSU_SDL3=1"

        # force entire pipewire graph to output to 64/44100
        "PIPEWIRE_QUANTUM=64/44100"
        # period bytes are 2x the quantum.
        ''PIPEWIRE_ALSA="{ alsa.buffer-bytes=768 alsa.period-bytes=128 }"''

      ]
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
