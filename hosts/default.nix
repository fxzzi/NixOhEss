{
  hostName,
  lib,
  ...
}: {
  networking.hostName = hostName;
  imports = [
    ./${hostName}
    ./${hostName}/hardware-configuration.nix
    ./modules
  ];

  # nano is enabled by default. no.
  # also dont install any of the default packages.
  programs.nano.enable = lib.mkDefault false;
  environment.defaultPackages = lib.mkDefault [];

  # enable microcode updates n stuff
  hardware.enableRedistributableFirmware = true;
}
