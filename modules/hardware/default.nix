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
        pkgs.wooting-udev-rules
        pkgs.via
      ];
      extraRules = ''
        # Allow configuring scyrox mice (compx)
        KERNEL=="hidraw*", ATTRS{idVendor}=="3554", MODE="0666", TAG+="uaccess"
      '';
    };
  };
}
