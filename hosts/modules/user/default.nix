{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  options.user.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable basic user configuration, adding them to some vital groups, and setting their shell.";
  };
  options.user.shell = lib.mkOption {
    type = lib.types.str;
    default = "zsh";
    description = "Change the users shell.";
  };
  config = lib.mkIf config.user.enable {
		age.secrets.userpass.file = ../../../secrets/userpass.age;
    environment.shells = [pkgs.${config.user.shell}];
    environment.pathsToLink = ["/share/zsh"];
    users.users.${user} = {
			hashedPasswordFile = config.age.secrets.userpass.path; 
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "gamemode"
        "networkmanager"
        "video"
      ];
      shell = pkgs.${config.user.shell}; # Set shell to zsh

      # See: https://github.com/nix-community/home-manager/issues/108
      ignoreShellProgramCheck = true;
    };
  };
}
