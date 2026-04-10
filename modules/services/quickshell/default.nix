{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption concatStringsSep;
  cfg = config.cfg.services.quickshell;
  inherit (pkgs) quickshell;
in {
  options.cfg.services.quickshell.enable = mkEnableOption "quickshell";
  config = mkIf cfg.enable {
    hj = {
      # xdg.config.files."quickshell".source = ./files;
      systemd.services.quickshell = {
        unitConfig = {
          Description = "Quickshell";
          PartOf = [
            "tray.target"
            "graphical-session.target"
          ];
          After = "graphical-session.target";
        };
        serviceConfig = {
          ExecStart = lib.getExe quickshell;
          Restart = "on-failure";
        };
        restartTriggers = [
          quickshell
          config.hj.xdg.config.files."quickshell".source
        ];
        path = with pkgs; [
          bash
          coreutils
          gawk
          ripgrep
          procps
          util-linux
        ];
        environment.QML2_IMPORT_PATH = concatStringsSep ":" [
          # "${quickshell}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
        ];
      };
    };
  };
}
