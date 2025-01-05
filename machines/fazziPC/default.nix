{ ... }: {
  networking.hostName = "fazziPC";
  imports = [
    ../global
    ./hardware-configuration.nix
    ./boot
    ./steam
    ./nvidia
    ./fancontrol
    ./networking
  ];
}
