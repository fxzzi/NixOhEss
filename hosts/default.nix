{
  hostName,
  lib,
  ...
}: {
  networking.hostName = hostName;
  imports = [
    ./${hostName}.nix
    ./hardware-configurations/${hostName}.nix
    ./modules
  ];

  # never change this. trust me.
  system.stateVersion = "22.11";

  # nano is enabled by default. no.
  # also dont install any of the default packages.
  programs.nano.enable = lib.mkDefault false;
  environment.defaultPackages = lib.mkDefault [];
  hardware.enableRedistributableFirmware = true;
}
