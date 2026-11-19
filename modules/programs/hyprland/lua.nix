{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.cfg.programs.hyprland;
  inherit (lib)
    generators
    getExe
    getExe'
    mkIf
    mkOption
    optionalString
    types
    ;

  multiMonitor = cfg.secondaryMonitor != null;

  selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  azzipkgs = inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system};

  # values exposed to the lua config as the global `nix` table.
  nixVars = {
    inherit (config.cfg.core) isLaptop;
    inherit multiMonitor;
    monitors = {
      default = cfg.defaultMonitor;
      secondary = if multiMonitor then cfg.secondaryMonitor else cfg.defaultMonitor;
    };
    bin = {
      screenshot = getExe azzipkgs.screenshot;
      audio = getExe azzipkgs.audio;
      brightness =
        if config.cfg.core.isLaptop then
          getExe azzipkgs.brightness-laptop # uses brightnessctl
        else
          getExe azzipkgs.brightness; # uses hyprsunset instead
      mpc = getExe pkgs.mpc;
      swappy = getExe pkgs.swappy;
      xrandr = getExe pkgs.xrandr;
      sunset = getExe azzipkgs.sunset;
      randomWall = getExe selfPkgs.random-wall;
      dunstify = getExe' pkgs.dunst "dunstify";
    };
  };
in
{
  options.cfg.programs.hyprland.extraConfig = mkOption {
    type = types.str;
    default = "";
    description = "Extra lua configuration for Hyprland";
  };
  config = mkIf cfg.enable {
    hj.xdg.config.files = {
      "hypr/hyprland.lua".text = # lua
        ''
          -- values from nix, used by the files in ./lua
          nix = ${generators.toLua { } nixVars}

          ${optionalString config.cfg.programs.wallust.enable ''
            require("colors_hyprland")
          ''}
          -- apply the hl.config block from nix
          hl.config(${generators.toLua { } cfg.extraHlConfig})

          -- load everything in ./lua
          require("${./lua}/*")

          -- extra text config
          ${cfg.extraConfig}
        '';
    };
  };
}
