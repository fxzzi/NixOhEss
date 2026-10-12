{ pkgs, ... }: {
  config = {
    # enable microcode updates n stuff
    hardware.enableRedistributableFirmware = true;

    # don't use ini generator, order matters here
    # disable debounce in libinput, so you can click fast :D
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Disable Mouse Debouncing]
      MatchUdevType=mouse
      ModelBouncingKeys=1
    '';

    services.udev = {
      packages = [
        # Allows WebUSB for flashing the "Wacom One" series of drawing tablets.
        (pkgs.writeTextDir "lib/udev/rules.d/70-lc87.rules" ''
          KERNEL=="hidraw*", ATTRS{idVendor}=="056a", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTR{idVendor}=="0ac3", TAG+="uaccess"
        '')
        # https://get.vial.today/manual/linux-udev.html#generalized-via-udev-rule
        # Allows most WebUSB configurators to work (Wootility, VIA, MCHOSE, Scyrox)
        (pkgs.writeTextDir "lib/udev/rules.d/92-viia.rules" ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
        '')
      ];
    };
  };
}
