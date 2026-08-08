{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.chroma;
in {
  options.cfg.services.chroma.enable = mkEnableOption "chroma";
  config = mkIf cfg.enable {
    hj = {
      xdg.data.files."walls".source = "${inputs.walls}/images"; # wallpapers

      # packages = [chroma];
      xdg.config.files."chroma/chroma.toml" = {
        generator = (pkgs.formats.toml {}).generate "chroma.toml";
        value = {
          default_image = "$XDG_STATE_HOME/wallpaper";
          ipc.enable = true;
          transition = {
            enable = true;
            duration_ms = 200;
          };
        };
      };

      # systemd.services.chroma = {
      #   description = "Lightweight wallpaper daemon for Wayland";
      #   after = ["graphical-session.target"];
      #   wantedBy = ["graphical-session.target"];
      #   partOf = ["graphical-session.target"];
      #   unitConfig = {
      #     ConditionEnvironment = "WAYLAND_DISPLAY";
      #   };
      #   serviceConfig = {
      #     Type = "simple";
      #     Restart = "always";
      #     ExecStart = getExe chroma;
      #   };
      #   restartTriggers = [
      #     config.hj.xdg.config.files."chroma/chroma.toml".source
      #     chroma
      #   ];
      # };
    };
  };
}
