{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  options.cfg.user.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable basic user configuration, adding them to some vital groups, and setting their shell.";
  };
  options.cfg.user.shell = lib.mkOption {
    type = lib.types.str;
    default = "zsh";
    description = "Change the users shell.";
  };
  config = lib.mkIf config.cfg.user.enable {
    environment = {
      shells = [pkgs.${config.cfg.user.shell}];
      pathsToLink = ["/share/zsh"];
    };
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "input"
      ];
      shell = pkgs.${config.cfg.user.shell}; # Set shell to zsh
      uid = 1000;

      # NOTE: https://github.com/nix-community/home-manager/issues/108
      ignoreShellProgramCheck = true;
    };
  };
}
