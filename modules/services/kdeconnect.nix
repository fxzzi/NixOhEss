{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe';
  cfg = config.cfg.services.kdeconnect;
in
{
  options.cfg.services.kdeconnect.enable = mkEnableOption "kdeconnect";
  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "kdeconnect";
        paths = [ pkgs.kdePackages.kdeconnect-kde ];
        # we don't want the indicator app in app launchers.
        postBuild = ''
          unlink $out/share/applications/org.kde.kdeconnect.nonplasma.desktop
        '';
      };
    };
    systemd.user.services = {
      kdeconnect = self.lib.mkGraphicalService {
        description = "KDE Connect daemon";
        exec = getExe' config.programs.kdeconnect.package "kdeconnectd";
        extra.serviceConfig.Restart = "on-abort";
      };
      kdeconnect-indicator = self.lib.mkGraphicalService {
        description = "KDE Connect indicator";
        exec = getExe' config.programs.kdeconnect.package "kdeconnect-indicator";
        extra = {
          serviceConfig.Restart = "on-abort";
          # lets you open kdeconnect from the tray icon
          path = [ config.programs.kdeconnect.package ];
        };
      };
    };
  };
}
