{
  lib,
  self,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.chroma;
  chroma = pkgs.callPackage "${inputs.chroma}/nix/package.nix" { };
in
{
  options.cfg.services.chroma.enable = mkEnableOption "chroma";
  config = mkIf cfg.enable {
    hj = {
      # xdg.data.files."walls".source = "${inputs.walls}/images"; # wallpapers

      xdg.config.files."chroma/chroma.toml" = {
        generator = (pkgs.formats.toml { }).generate "chroma.toml";
        value = {
          default_image = "$XDG_STATE_HOME/wallpaper";
          filter_quality = "linear";
          downsampling.enable = false;

          # transition.enable = true;

          ipc = {
            enable = true;
            socket_path = "$XDG_RUNTIME_DIR/chroma.sock";
          };
        };
      };

      systemd.services.chroma = self.lib.mkGraphicalService {
        description = "Fast, lightweight and efficient wallpaper daemon for Wayland.";
        exec = getExe chroma;
        extra.restartTriggers = [
          config.hj.xdg.config.files."chroma/chroma.toml".source
          chroma
        ];
      };
    };
  };
}
