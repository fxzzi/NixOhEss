{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (inputs) hjem;
  inherit (config.cfg.core) username;
in {
  options.cfg.core.username = mkOption {
    type = types.str;
    default = "user";
    description = "Sets the username for the system.";
  };
  imports = [
    hjem.nixosModules.default
    # avoid boilerplate in the configuration
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
      # PLEASE change this after logging in
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
