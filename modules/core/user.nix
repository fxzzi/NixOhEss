{
  pkgs,
  lib,
  npins,
  config,
  options,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (config.cfg.core) username;
in {
  options.cfg.core.username = mkOption {
    type = types.str;
    default = "faaris";
    description = "Sets the username for the system.";
  };
  imports = [
    (lib.modules.importApply "${npins.hjem}/modules/nixos" {
      inherit pkgs config lib options;
      hjem-lib = import "${npins.hjem}/lib.nix" {inherit lib pkgs;};
    })
    # Allow using `hj` in configuration to
    # easily configure hjem in any file.
    # This pretty much makes or breaks my config.
    (mkAliasOptionModule ["hj"] ["hjem" "users" username])
  ];
  config = {
    hjem = {
      linker = pkgs.smfh;
      clobberByDefault = true;
      users.${username} = {
        enable = true;
        # These are available no matter the host.
        packages = with pkgs; [
          pkgs.npins
          wget
          ffmpeg
          imagemagick
          pwvucontrol
          mate.atril
          mate.eom
          libreoffice
          hunspell
          hunspellDicts.en_GB-ise
          nix-tree
        ];
      };
    };
    users.users.${username} = {
      isNormalUser = true;
      # so you can login the first time.
      # PLEASE change this after logging in :prayge:
      initialPassword = "1234";
      extraGroups = [
        "wheel" # sudo
        "video"
        "input"
      ];
      uid = 1000;
    };
    xdg.mime.defaultApplications = {
      "application/pdf" = "atril.desktop";

      "image/png" = "eom.desktop";
      "image/jpeg" = "eom.desktop";
      "image/jpg" = "eom.desktop";
      "image/gif" = "eom.desktop";
      "image/webp" = "eom.desktop";
      "image/bmp" = "eom.desktop";
      "image/tiff" = "eom.desktop";
      "image/svg+xml" = "eom.desktop";
    };
    environment.sessionVariables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
