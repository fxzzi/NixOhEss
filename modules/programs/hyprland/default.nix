{
  self,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    generators
    getExe
    getExe'
    mkEnableOption
    mkOption
    mkIf
    optionalString
    types
    ;
  cfg = config.cfg.programs.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandSet = if cfg.useGit then inputs.hyprland.packages.${system} else pkgs;

  selfPkgs = self.packages.${system};
  azzipkgs = inputs.azzipkgs.packages.${system};

  # values exposed to the lua config as the global `nix` table.
  nixVars = {
    inherit (config.cfg.core) isLaptop;
    monitors = {
      default = cfg.defaultMonitor;
      secondary = cfg.secondaryMonitor; # nil in lua if unset
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
  options.cfg.programs.hyprland = {
    enable = mkEnableOption "Hyprland";
    useGit = mkOption {
      type = types.bool;
      default = false;
      description = "Use Hyprland from the flake.";
    };
    defaultMonitor = mkOption {
      type = types.str;
      default = "DP-1";
      description = "Sets the default monitor for hypr*";
    };
    secondaryMonitor = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Sets the secondary monitor for hypr*.";
    };
    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra lua configuration for Hyprland";
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandSet.hyprland;
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland;
    };
    hj.xdg.config.files = {
      "hypr/hyprland.lua".text = # lua
        ''
          -- values from nix, used by the files in ./lua
          nix = ${generators.toLua { } nixVars}

          ${optionalString config.cfg.programs.wallust.enable ''
            require("colors_hyprland")
          ''}
          -- apply the hl.config block from nix
          hl.config(${generators.toLua { } cfg.hlConfig})

          -- load everything in ./lua
          require("${./lua}/*")

          -- extra text config
          ${cfg.extraConfig}
        '';
      "wallust/wallust.toml".value.templates.hyprland = mkIf config.cfg.programs.wallust.enable {
        target = "~/.config/hypr/colors_hyprland.lua";
        template = builtins.toFile "colors_hyprland.lua" ''
          hl.config(${
            generators.toLua { } {
              general.col = {
                active_border = "rgb({{color4 | strip}})";
                inactive_border = "rgba({{color0 | strip}}ff)";
              };
            }
          })
        '';
      };
    };
  };
}
