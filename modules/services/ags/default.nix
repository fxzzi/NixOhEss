{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (pkgs) callPackage;
  cfg = config.cfg.services.ags;
  pkg = callPackage "${npins.rags}/nix/package.nix" {
    buildTypes = false;
    extraPackages = [
      pkgs.libgtop
    ];
  };
in {
  options.cfg.services.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkg
      ];
      xdg.config.files = {
        "ags/icons".source = ./ags/icons;
        "ags/modules".source = ./ags/modules;
        "ags/config.js".source = ./ags/config.js;
        "ags/style.css".source = ./ags/style.css;
      };
    };
    systemd.user.services.ags = {
      enable = true;
      description = "ags widgets";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${getExe pkg}";
      };
    };
    services.upower.enable = config.cfg.services.watt.enable; # enable battery module if watt is in use, its a good indicator of whether we're on a laptop.
  };
}
