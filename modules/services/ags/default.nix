{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.ags;
  pkg = inputs.rags.packages.${pkgs.stdenv.hostPlatform.system}.agsNoTypes.override {
    extraPackages = [
      pkgs.libgtop
    ];
  };
in
{
  options.cfg.services.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkg
      ];
      xdg.config.files = {
        "ags/icons".source = ./icons;
        "ags/modules".source = ./modules;
        "ags/config.js".source = ./config.js;
        "ags/style.css".source = ./style.css;
        "wallust/wallust.toml".value.templates.ags = mkIf config.cfg.programs.wallust.enable {
          target = "~/.config/ags/colors_ags.css";
          template = builtins.toFile "colors_ags.css" ''
            @define-color cursor {{cursor}};
            @define-color background rgba({{background | rgb}},0.85);
            @define-color foreground {{foreground}};
            @define-color color0  {{color0 }};
            @define-color color1  {{color1 }};
            @define-color color2  {{color2 }};
            @define-color color3  {{color3 }};
            @define-color color4  {{color4 }};
            @define-color color5  {{color5 }};
            @define-color color6  {{color6 }};
            @define-color color7  {{color7 }};
            @define-color color8  {{color8 }};
            @define-color color9  {{color9 }};
            @define-color color10 {{color10}};
            @define-color color11 {{color11}};
            @define-color color12 {{color12}};
            @define-color color13 {{color13}};
            @define-color color14 {{color14}};
            @define-color color15 {{color15}};
          '';
        };
      };

      systemd.services.ags = {
        description = "Aylur's GTK Shell";
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        unitConfig = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          ExecStart = "${getExe pkg}";
        };
        restartTriggers = [
          config.hj.xdg.config.files."ags/config.js".source
          config.hj.xdg.config.files."ags/style.css".source
          config.hj.xdg.config.files."ags/icons".source
          config.hj.xdg.config.files."ags/modules".source
          pkg
        ];
      };
    };
    services.upower.enable = config.cfg.core.isLaptop;
  };
}
