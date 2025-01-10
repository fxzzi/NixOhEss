{hostName, ...}: {
  networking.hostName = hostName;
  imports = [
    ./${hostName}.nix
    ./hardware-configurations/${hostName}.nix
    ./modules
  ];

  # never change this. trust me.
  system.stateVersion = "22.11";
}
