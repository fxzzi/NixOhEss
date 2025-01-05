{ config, pkgs, ... }: {
  boot = {
    initrd = {
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };
    kernelModules = [ "nct6775" ];
    kernelPackages =
      pkgs.linuxKernel.packages.linux_zen; # Set kernel to linux_zen
    extraModulePackages = with config.boot.kernelPackages; [
      zenpower
      xone
    ]; # Add xone package for Xbox Controller support, zenpower for ryzen sensors
    blacklistedKernelModules =
      [ "k10temp" ]; # Blacklist k10temp because zenpower provides it
    kernel.sysctl = {
      # for gaming :cOoL:
      "vm.max_map_count" = 2147483642;
    };
  };
  hardware.xone.enable = true; # Enable xone module
}
