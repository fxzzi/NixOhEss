{
  lib,
  config,
  self,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.osu;
  otd = config.cfg.services.opentabletdriver.enable;
  # osu!lazer needs to be up to date. fuf's nix-gaming repo
  # updates it faster and more regularly than nixpkgs.
  osu = self.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
    # allows for really low latency. if audio is glitching, increase
    pipewire_latency = "32/44100";
    command_prefix = "env SDL_VIDEODRIVER=wayland";
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
