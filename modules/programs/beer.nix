{
  lib,
  config,
  pkgs,
  inputs,
  self,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkAfter
    getExe
    getExe'
    ;
  cfg = config.cfg.programs.beer;
  beer = pkgs.callPackage "${inputs.beer}/nix/package.nix" { };
in
{
  options.cfg.programs.beer.enable = mkEnableOption "beer";
  config = mkIf cfg.enable {
    hj = {
      packages = [ beer ];
      systemd.services.beer = self.lib.mkGraphicalService {
        description = "A terminal worth pouring time into";
        exec = "${getExe beer} --server";
        extra = {
          reloadTriggers = [ config.hj.xdg.config.files."beer/beer.toml".source ];
          serviceConfig.ExecReload = "${getExe' pkgs.coreutils "kill"} -USR1 $MAINPID";
        };
      };
      xdg.config.files = {
        "beer/beer.toml" = {
          generator = (pkgs.formats.toml { }).generate "beer.toml";
          value = {
            main = {
              font-size = 17;
              subpixel = config.fonts.fontconfig.subpixel.rgba;
              # glyphs in nh aren't followed by a space so they appear squished
              # so allow glyphs to always overflow to fix that
              glyph-overflow = "always";

              pad-x = 8;
              pad-y = 8;
            };
            colors = {
              alpha = 0.8;
            };
            cursor.style = "beam";
          };
        };
        "wallust/wallust.toml".value = {
          hooks.beer = "systemctl --user reload beer";
          templates.beer = mkIf config.cfg.programs.wallust.enable {
            target = "~/.config/beer/beer.d/colors_beer.toml";
            template = (pkgs.formats.toml { }).generate "colors_beer.toml" {
              colors = {
                background = "{{background}}";
                foreground = "{{foreground}}";
                cursor = "{{cursor}}";

                selection-background = "{{foreground}}";
                selection-foreground = "{{background}}";

                regular = [
                  "{{color0}}"
                  "{{color1}}"
                  "{{color2}}"
                  "{{color3}}"
                  "{{color4}}"
                  "{{color5}}"
                  "{{color6}}"
                  "{{color7}}"
                ];

                bright = [
                  "{{color8}}"
                  "{{color9}}"
                  "{{color10}}"
                  "{{color11}}"
                  "{{color12}}"
                  "{{color13}}"
                  "{{color14}}"
                  "{{color15}}"
                ];
              };
            };
          };
        };
      };
    };

    # zsh shell integration for OSC7, so Ctrl-Shift-N can carry through the CWD
    # mkAfter so that add-zsh-hook is available
    # <https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory>
    programs.zsh.interactiveShellInit =
      mkAfter
        # sh
        ''
          function osc7-pwd() {
              emulate -L zsh # also sets localoptions for us
              setopt extendedglob
              local LC_ALL=C
              printf '\e]7;file://%s%s\e\' $HOST ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
          }

          function chpwd-osc7-pwd() {
              (( ZSH_SUBSHELL )) || osc7-pwd
          }
          add-zsh-hook -Uz chpwd chpwd-osc7-pwd
        '';

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "dev.notashelf.beer.desktop"
      ];
    };
  };
}
