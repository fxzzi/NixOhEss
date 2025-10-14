{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.dunst;
in {
  options.cfg.services.dunst.enable = mkEnableOption "dunst";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.dunst
      ];
      xdg.config.files."dunst/dunstrc" = {
        generator = lib.generators.toINI {};
        value = {
          global = {
            follow = "mouse";
            width = "(256,448)";
            origin = "top-right";
            offset = "(2,2)";
            notification_limit = 0;
            progress_bar = true;
            progress_bar_height = 10;
            progress_bar_frame_width = 0;
            progress_bar_corner_radius = 5;
            icon_corner_radius = 0;
            indicate_hidden = true;
            separator_height = 2;
            padding = 6;
            horizontal_padding = 6;
            text_icon_padding = 6;
            frame_width = 1;
            gap_size = 2;
            separator_color = "frame";
            sort = true;
            font = "monospace 12";
            markup = "full";
            format = "<b>%s</b>\\n%b";
            alignment = "left";
            vertical_alignment = "center";
            show_age_threshold = 30;
            ellipsize = "end";
            stack_duplicates = true;
            show_indicators = false;
            enable_recursive_icon_lookup = true;
            icon_position = "left";
            min_icon_size = 48;
            max_icon_size = 96;
            icon_theme = "Papirus-Dark, Papirus";
            sticky_history = true;
            history_length = 25;
            dmenu = "fuzzel -d";
            browser = "librewolf";
            always_run_script = true;
            layer = "overlay";
            mouse_left_click = "close_current";
            mouse_middle_click = "do_action, close_current";
            mouse_right_click = "close_all";
          };
          urgency_low = {
            timeout = 2;
          };
          urgency_normal = {
            timeout = 4;
          };
          urgency_critical = {
            timeout = 6;
          };
          screenshot = {
            appname = "screenshot";
            max_icon_size = 192;
            timeout = 3;
          };
          audio = {
            appname = "audio";
            timeout = 2;
          };
          brightness = {
            appname = "brightness";
            timeout = 2;
          };
          mpd = {
            appname = "mpd";
            max_icon_size = 96;
            word_wrap = false;
            timeout = 3;
          };
        };
      };
    };
    systemd.user.services.dunst = {
      enable = true;
      unitConfig = {
        Description = "Dunst notification daemon";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${getExe pkgs.dunst}";
      };
    };
  };
}
