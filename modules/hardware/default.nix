{ pkgs, ... }: {
  config = {
    # enable microcode updates n stuff
    hardware.enableRedistributableFirmware = true;

    # don't use ini generator, order matters here
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Disable Mouse Debouncing]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';

    services.udev = {
      packages = [
        # this udev package sets a rule which also
        # covers wooting keyboards, and scyrox mice.
        pkgs.via
      ];
      extraRules = ''
        # use the kyber i/o scheduler on ssd's.
        ACTION=="add|change", KERNEL=="nvme*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
        # allow access to flash update mode of wacom tablets
        KERNEL=="hidraw*", ATTRS{idVendor}=="056a", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0ac3", TAG+="uaccess"
      '';
    };
  };
}
