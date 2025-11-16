{
  self',
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.foot;
  inherit (pkgs) symlinkJoin;
  foot = self'.packages.foot-transparency;
in {
  options.cfg.programs.foot.enable = mkEnableOption "foot";
  config = mkIf cfg.enable {
    hj.packages = [
      (symlinkJoin {
        inherit (foot) name pname version meta;
        paths = [foot];
        # remove foot desktop files for server and client, as
        # we just use standalone anyway
        postBuild = ''
          unlink $out/share/applications/footclient.desktop
          unlink $out/share/applications/foot-server.desktop
        '';
      })
    ];
    hj.xdg.config.files = {
      "foot/foot.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "monospace:size=12";
            pad = "6x6";
            transparent-fullscreen = true; # option added by my fork
          };
          cursor = {
            style = "beam";
          };
          mouse = {
            hide-when-typing = true;
          };
          colors = {
            alpha = 0.85;
            alpha-mode = "matching";
          };
        };
      };
      # zsh shell integration. see:
      #  <https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory>
      "zsh/.zshrc".text = ''
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
    };
    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "foot.desktop"
      ];
    };
  };
}
