{ inputs, npins, user, hostName, ... }:
{
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${user} = import ../../home;
    extraSpecialArgs = {
      inherit
        inputs
        npins
        user
        hostName
        ;
    };
  };

}
