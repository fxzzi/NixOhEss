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

    # turn off any debouncing built into libinput
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Never Debounce]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';
  };
}
