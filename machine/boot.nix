{ config, pkgs, ... }:
{
  boot = {
		initrd = {
			kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
		};
    loader = {
      timeout = 3; # Timeout before launching default entry
      systemd-boot = {
        enable = true; # Enable systemd-boot
        editor = false; # Disable editor for security
        consoleMode = "max"; # Set console mode to max resolution
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "nowatchdog" "mitigations=off" ]; # Enable amd_pstate, disable watchdog and mitigations (not needed on personal systems)
    kernelModules = [ "nct6775" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen; # Set kernel to linux_zen
    extraModulePackages = with config.boot.kernelPackages; [ zenpower xone ]; # Add xone package for Xbox Controller support, zenpower for ryzen sensors
    blacklistedKernelModules = [ "k10temp" ]; # Blacklist k10temp because zenpower provides it
    tmp.useTmpfs = true; # /tmp is not on tmpfs by default (why??)
    tmp.tmpfsSize = "50%";
    kernel.sysctl = {
			# for gaming :cOoL:
      "vm.max_map_count" = 2147483642;
    };
  };

  hardware.xone.enable = true; # Enable xone module

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Set a percentage of RAM to zstd compressed swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
