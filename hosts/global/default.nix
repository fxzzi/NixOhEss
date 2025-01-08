{
  inputs,
  npins,
  user,
  hostName,
  ...
}:
{
  environment.pathsToLink = [ "/share/zsh" ];
  imports = [
    ./audio
    ./boot
    ./cachix
    ./fonts
    # ./getty-tty1-only-password
    ./networking
    ./opentabletdriver
    ./services
    ./state
    ./user
    ./wayland
  ];
  nixpkgs.config.allowUnfree = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${user} = import ../../home/${hostName}.nix;
    extraSpecialArgs = {
      inherit
        inputs
        npins
        user
        ;
    };
  };
}
