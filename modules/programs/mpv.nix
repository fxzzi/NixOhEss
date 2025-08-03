{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) generators concatStringsSep mapAttrsToList mkEnableOption mkIf;
  inherit (builtins) typeOf stringLength toString;

  yesNo = value:
    if value
    then "yes"
    else "no";

  renderOption = option:
    rec {
      int = toString option;
      float = int;
      bool = yesNo option;
      string = option;
    }
    .${
      typeOf option
    };

  renderOptionValue = value: let
    rendered = renderOption value;
    length = toString (stringLength rendered);
  in "%${length}%${rendered}";

  renderOptions = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {mkValueString = renderOptionValue;} "=";
    listsAsDuplicateKeys = true;
  };

  renderBindings = bindings: concatStringsSep "\n" (mapAttrsToList (name: value: "${name} ${value}") bindings);
in {
  options.cfg.programs.mpv.enable = mkEnableOption "mpv";
  config = mkIf config.cfg.programs.mpv.enable {
    hj = {
      packages = [pkgs.mpv];
      files = {
        ".config/mpv/mpv.conf".text = renderOptions {
          save-position-on-quit = true;
          force-seekable = true;

          demuxer-max-back-bytes = "20M";
          demuxer-max-bytes = "20M";

          vlang = "en,eng";
          vo = "gpu-next";
          # gpu-context = "wayland"; # waylandvk broken on nvidia

          volume-max = 150; # allow some overamp
          volume = 100;

          keep-open = true;
          pause = false;

          hwdec = "auto";

          alang = "en,eng";
          embeddedfonts = false; # just use system fonts
          slang = "en,eng";
          sub-auto = "all";
          sub-color = "#A9B1D6";
          sub-file-paths-append = [
            "Subs/\${filename/no-ext}"
            "Subs/\${filename}"
            "subs/\${filename/no-ext}"
            "subs/\${filename}"
            "ASS"
            "Ass"
            "SRT"
            "Srt"
            "Sub"
            "Subs"
            "Subtitles"
            "ass"
            "srt"
            "sub"
            "subs"
            "subtitles"
          ];
          sub-fix-timing = false;
          sub-font-size = 36;
          sub-font = "${builtins.head config.fonts.fontconfig.defaultFonts.sansSerif}";
          sub-scale-with-window = true;

          cursor-autohide = 250;
          cursor-autohide-fs-only = true;
          msg-color = true;
          msg-module = true;
          term-osd-bar = true;
        };
        ".config/mpv/input.conf".text = renderBindings {
          "MOUSE_BTN0" = "show-progress";
          "MOUSE_BTN0_DBL" = "cycle fullscreen";
          "MOUSE_BTN2" = "cycle pause";

          "RIGHT" = "osd-msg-bar seek +5 relative+keyframes";
          "LEFT" = "osd-msg-bar seek -5 relative+keyframes";
          "SHIFT+RIGHT" = "osd-msg-bar seek +1 relative+exact";
          "SHIFT+LEFT" = "osd-msg-bar seek -1 relative+exact";
          "CTRL+RIGHT" = ''frame-step ; show-text "Frame: ''${estimated-frame-number} / ''${estimated-frame-count}"'';
          "CTRL+LEFT" = ''frame-back-step ; show-text "Frame: ''${estimated-frame-number} / ''${estimated-frame-count}"'';

          "UP" = "osd-msg-bar seek +30 relative+keyframes";
          "DOWN" = "osd-msg-bar seek -30 relative+keyframes";
          "SHIFT+UP" = "osd-msg-bar seek +120 relative+keyframes";
          "SHIFT+DOWN" = "osd-msg-bar seek -120 relative+keyframes";

          "PGUP" = "osd-msg-bar seek +600 relative+keyframes";
          "PGDWN" = "osd-msg-bar seek -600 relative+keyframes";

          "SHIFT+PGUP" = "osd-msg-bar seek +1200 relative+keyframes";
          "SHIFT+PGDWN" = "osd-msg-bar seek +1200 relative+keyframes";

          "-" = ''add volume -2 ; show-text "Volume: ''${volume}"'';
          "=" = ''add volume +2 ; show-text "Volume: ''${volume}"'';

          "Q" = "quit";
          "u" = ''cycle-values hwdec "nvdec" "no"'';

          "i" = "script-binding stats/display-stats";
          "I" = "script-binding stats/display-stats-toggle";
          "o" = "cycle-values osd-level 3 1";
          "p" = "cycle-values video-rotate 90 180 270 0";
          "P" = ''cycle-values video-aspect "16:9" "4:3" "2.35:1" "16:10"'';

          "a" = "cycle audio";

          "s" = "cycle sub";
          "S" = "cycle sub-visibility";
          "CTRL+s" = "cycle secondary-sid";

          "l" = ''cycle-values loop-file yes no ; show-text "''${?=loop-file==inf:Looping enabled (file)}''${?=loop-file==no:Looping disabled (file)}"'';

          "ESC" = "cycle fullscreen";
          "SPACE" = "cycle pause";
          "m" = "cycle mute";
        };
      };
    };
    xdg.mime.defaultApplications = {
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop"; # MKV
      "video/webm" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop"; # MP3
      "audio/ogg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
    };
  };
}
