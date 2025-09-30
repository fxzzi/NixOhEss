{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe';
  cfg = config.cfg.services.kdeconnect;
in {
  options.cfg.services.kdeconnect.enable = mkEnableOption "kdeconnect";
  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.symlinkJoin {
        inherit (pkgs.kdePackages.kdeconnect-kde) name pname version meta;
        paths = [pkgs.kdePackages.kdeconnect-kde];
        # we don't want the indicator app in app launchers.
        postBuild = ''
          unlink $out/share/applications/org.kde.kdeconnect.nonplasma.desktop
        '';
      };
    };
    systemd.user.services = {
      kdeconnect = {
        enable = true;
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig = {
          ExecStart = getExe' pkgs.kdePackages.kdeconnect-kde "kdeconnectd";
          Restart = "on-abort";
        };
      };
      kdeconnect-indicator = {
        enable = true;
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig = {
          ExecStart = getExe' pkgs.kdePackages.kdeconnect-kde "kdeconnect-indicator";
          Restart = "on-abort";
        };
        # lets you open kdeconnect from the tray icon
        path = [config.programs.kdeconnect.package];
      };
    };
  };
}
