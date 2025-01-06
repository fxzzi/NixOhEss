{ pkgs, user, ... }:
{
  environment.shells = [ pkgs.zsh ];
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gamemode"
    ];
    shell = pkgs.zsh; # Set shell to zsh

    # See: https://github.com/nix-community/home-manager/issues/108
    ignoreShellProgramCheck = true;
  };
}
