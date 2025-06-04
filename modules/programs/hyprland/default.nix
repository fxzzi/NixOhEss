{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  pkg =
    if config.cfg.gui.hypr.useGit
    then inputs.hyprland.packages.${pkgs.system}
    else pkgs;
  patches =
    if config.cfg.gui.hypr.useGit
    then [
      # (pkgs.fetchpatch
      #   {
      #     url = "https://github.com/hyprwm/Hyprland/pull/10364.patch";
      #     sha256 = "sha256-M/T4B2sJeyLB6nKTJqouuxWzmno3lfjLpO3yNbxcvw4=";
      #   })
    ]
    else [];
  uwsm = lib.getExe' config.programs.uwsm.package "uwsm";
  uwsmEnabled = config.cfg.wayland.uwsm.enable;
  autoStartCmd =
    if uwsmEnabled
    then ''
      if ${uwsm} check may-start; then
      exec ${uwsm} start hyprland-uwsm.desktop
      fi
    ''
    else ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec ${lib.getExe' config.programs.hyprland.package "Hyprland"}
      fi
    '';
in {
  options.cfg.gui = {
    hypr = {
      hyprland = {
        enable = lib.mkEnableOption "Hyprland";
        autoStart = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables hyprland to run automatically in tty1 (zsh)";
        };
      };
      useGit = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Makes nix use hypr* packages from flakes instead of nixpkgs";
      };
    };
  };
  imports = [
    inputs.hyprland.nixosModules.default
    ./env.nix
    ./settings.nix
  ];

  config = lib.mkIf config.cfg.gui.hypr.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = pkg.hyprland.overrideAttrs {
        inherit patches;
      };
      portalPackage = pkg.xdg-desktop-portal-hyprland;
      withUWSM = config.cfg.wayland.uwsm.enable;
    };
    environment.loginShellInit = lib.mkIf config.cfg.gui.hypr.hyprland.autoStart autoStartCmd;
  };
}
