{
  imports = [
    ./batmon.nix
    ./printing.nix
    ./rules.nix
    ./scanning.nix
    ./scx.nix

    ./gpu
  ];

  config = {
    # enable microcode updates n stuff
    hardware.enableRedistributableFirmware = true;
  };
}
