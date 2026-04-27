{pkgs, ...}: {
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

    services.udev = {
      packages = [
        # this udev package sets a rule which also
        # covers wooting keyboards, and scyrox mice.
        pkgs.via
      ];
      # use the kyber i/o scheduler on ssd's.
      extraRules = ''
        ACTION=="add|change", KERNEL=="nvme*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
      '';
    };
  };
}
