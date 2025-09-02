{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrsToList isList mkEnableOption getExe mkIf;
  inherit (builtins) typeOf toString;
  cfg = config.cfg.programs.ncmpcpp;

  renderSettings = settings: concatStringsSep "\n" (mapAttrsToList renderSetting settings);

  renderSetting = name: value: "${name}=${renderValue value}";

  renderValue = option:
    rec {
      int = toString option;
      bool =
        if option
        then "yes"
        else "no";
      string = option;
    }
    .${
      typeOf option
    };

  renderBindings = bindings: concatStringsSep "\n" (map renderBinding bindings);

  renderBinding = {
    key,
    command,
  }:
    concatStringsSep "\n  " ([''def_key "${key}"''] ++ maybeWrapList command);

  maybeWrapList = xs:
    if isList xs
    then xs
    else [xs];
in {
  options.cfg.programs.ncmpcpp.enable = mkEnableOption "ncmpcpp";
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        ncmpcpp
        (inputs.self.packages.${pkgs.system}).mpd-notif
      ];
      xdg.config.files = {
        "ncmpcpp/bindings".text = renderBindings [
          {
            key = "+";
            command = "volume_up";
          }
          {
            key = "=";
            command = "volume_up";
          }
          {
            key = "_";
            command = "volume_down";
          }
          {
            key = "-";
            command = "volume_down";
          }
        ];
        "ncmpcpp/config".text = renderSettings {
          # Directories
          lyrics_directory = "~/.local/share/ncmpcpp/lyrics/";

          # Mouse and scrolling
          mouse_support = "yes";
          lines_scrolled = "1";

          # Playlist settings
          playlist_shorten_total_times = "yes";
          autocenter_mode = "yes";

          # Editor
          external_editor = "nvim";

          # Progress bar settings
          progressbar_elapsed_color = "blue";
          progressbar_color = "black";
          progressbar_look = "▃▃▃";

          # UI
          user_interface = "alternative";
          playlist_display_mode = "classic";
          song_list_format = "$5{%a $2»$8 %t}$0";
          # hide playlist info
          header_visibility = "no";
          # hide current song highlight after 1 second
          playlist_disable_highlight_delay = 1;

          # Notifications
          execute_on_song_change = "${getExe inputs.self.packages.${pkgs.system}.mpd-notif}";
        };
      };
    };
    environment.shellAliases = {
      ncm = "${getExe pkgs.ncmpcpp}";
    };
  };
}
