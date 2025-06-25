{lib, ...}: {
  imports = [
    ./printing.nix
    ./rules.nix
    ./scanning.nix
    ./scx.nix
    ./gpu
  ];

  config = {
    # enable microcode updates n stuff
    hardware.enableRedistributableFirmware = true;

    environment.etc."libinput/local-overrides.quirks".text = ''
      [Disable Mouse Debouncing]
      MatchUdevType=mouse
      ModelBouncingKeys=1

      [Disable Tablet Smoothing]
      MatchUdevType=tablet
      AttrTabletSmoothing=0
    '';
  };
}
