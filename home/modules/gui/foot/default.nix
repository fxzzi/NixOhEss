{
  lib,
  config,
  pkgs,
  npins,
  ...
}: {
  options.gui.foot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the foot terminal and its configs";
  };
  options.gui.foot.zshIntegration = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the foot terminal and its configs";
  };
  config = lib.mkIf config.gui.foot.enable {
    programs.foot = {
      enable = true;
      package = pkgs.foot.overrideAttrs {
        pname = "foot-transparency";
        version = "0-unstable";
        src = npins.foot;
      };

      settings = {
        main = {
          font = "monospace:size=13";
          pad = "12x12 center";
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
    # NOTE: https://codeberg.org/dnkl/foot/wiki#user-content-shell-integration
    programs.zsh.initExtra = lib.mkIf config.gui.foot.zshIntegration ''
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
    # hide footclient and foot-server, they are useless
    xdg.desktopEntries = {
      foot-server = {
        name = "foot-server";
        noDisplay = true;
        exec = "";
      };
      footclient = {
        name = "footclient";
        noDisplay = true;
        exec = "";
      };
    };
  };
}
