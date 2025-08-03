{...}: {
  imports = [
    ./rules.nix
    ./scanning.nix
    ./gpu/nvidia
    ./gpu/amdgpu
  ];

  config = {
    # enable microcode updates n stuff
    hardware.enableRedistributableFirmware = true;

    # don't use ini generator, order matters here
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
