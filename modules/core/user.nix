{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (config.cfg.core) username;
in {
  options.cfg.core.username = mkOption {
    type = types.str;
    default = "user";
    description = "Sets the username for the system.";
  };
  imports = [
    inputs.hjem.nixosModules.default
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
          wget
          ffmpeg
          imagemagick
          lxqt.pavucontrol-qt
          mate.atril
          mate.eom
          libreoffice
          hunspell
          hunspellDicts.en_GB-ise
          npins
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
  };
}
