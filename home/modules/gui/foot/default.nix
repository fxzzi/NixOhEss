{
  lib,
  config,
  ...
}: {
  options.gui.foot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the foot terminal and its configs";
  };

  config = lib.mkIf config.gui.foot.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = "~/.cache/wallust/colors_foot.ini";
          font = "monospace:size=13";
          pad = "12x12 center";
          line-height = "19.5";
          alpha-mode = "matching";
          transparent-fullscreen = "yes";
        };
        cursor = {
          style = "beam";
        };
        mouse = {
          hide-when-typing = "yes";
        };
        colors = {
          alpha = "0.75";
        };
      };
    };
  };
}
