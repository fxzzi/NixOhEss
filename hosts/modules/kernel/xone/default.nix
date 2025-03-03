{
  config,
  lib,
  npins,
  ...
}: {
  options.kernel.xone.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the xone kernel driver, for connecting Xbox controllers wirelessly.";
  };
  config = lib.mkIf config.kernel.xone.enable {
    hardware.xone.enable = true;
    boot = {
      extraModulePackages = [
        # also install xpad-noone, for xbox 360 wired controllers
        (config.boot.kernelPackages.callPackage ./xpad-noone.nix {
          inherit npins;
        })
      ];
      kernelModules = ["xpad"];
    };
  };
}
