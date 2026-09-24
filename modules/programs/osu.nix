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
    command_prefix = concatStringsSep " " (
      [
        # this env var needs to be unset so that it can be
        # derived from our bass dev period var instead.
        "env --unset=PIPEWIRE_LATENCY"
        # uses sdl2 by default
        "OSU_SDL3=1"
        # https://github.com/ppy/osu-framework/pull/6724
        "OSU_TEMP_TESTING_BASS_CONFIG_DEV_PERIOD=-65"
      ]
      ++ optional config.cfg.programs.obs-studio.enable "obs-gamecapture"
      ++ optional config.cfg.programs.mangohud.enable "mangohud"
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
