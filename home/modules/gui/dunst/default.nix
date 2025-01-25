{
  lib,
  config,
  ...
}: {
  options.gui.dunst.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the dunst daemon.";
  };
  config = {
    services.dunst = lib.mkIf config.gui.dunst.enable {
      enable = true;
      iconTheme = {
        inherit (config.gtk.iconTheme) name;
        inherit (config.gtk.iconTheme) package;
      };
      settings = {
        global = {
          follow = "mouse";
          width = "(256,384)";
          origin = "top-right";
          offset = "(4,4)";
          notification_limit = 0;
          progress_bar = true;
          progress_bar_height = 14;
          progress_bar_frame_width = 0;
          progress_bar_corner_radius = 6;
          icon_corner_radius = 0;
          indicate_hidden = true;
          separator_height = 3;
          padding = 10;
          horizontal_padding = 10;
          text_icon_padding = 10;
          frame_width = 3;
          gap_size = 4;
          separator_color = "frame";
          sort = true;
          font = "monospace 14";
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
          icon_theme = config.services.dunst.iconTheme.name;
          sticky_history = true;
          history_length = 25;
          dmenu = "${lib.getExe config.programs.fuzzel.package} -d";
          browser = "${lib.getExe config.programs.librewolf.package}";
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
          timeout = 3;
        };
      };
    };
  };
}
