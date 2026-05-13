{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (pkgs) callPackage;
  cfg = config.cfg.services.ags;
  pkg =
    (callPackage "${pins.rags}/nix/package.nix" {
      buildTypes = false;
      extraPackages = [
        pkgs.libgtop
      ];
    }).overrideAttrs (oldAttrs: {
      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (oldAttrs) pname src pnpmInstallFlags;
        hash = "sha256-NNkbOBHRx13w6EwpEl+a8YucDuVja94Kj2vewvhu+wA=";
        fetcherVersion = 3; # https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm-fetcherVersion
      };
    });
in {
  options.cfg.services.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkg
      ];
      xdg.config.files = {
        "ags/icons".source = ./icons;
        "ags/modules".source = ./modules;
        "ags/config.js".source = ./config.js;
        "ags/style.css".source = ./style.css;
      };

      systemd.services.ags = {
        description = "Aylur's GTK Shell";
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
        restartTriggers = [
          config.hj.xdg.config.files."ags/config.js".source
          config.hj.xdg.config.files."ags/style.css".source
          config.hj.xdg.config.files."ags/icons".source
          config.hj.xdg.config.files."ags/modules".source
          pkg
        ];
      };
    };
    services.upower.enable = config.cfg.services.watt.enable; # enable battery module if watt is in use, its a good indicator of whether we're on a laptop.
  };
}
