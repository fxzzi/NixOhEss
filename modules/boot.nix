{ config, pkgs, ... }:
{
  boot = {
    loader = {
      timeout = 6; # Timeout before launching default entry
      systemd-boot = {
        enable = true; # Enable systemd-boot
        editor = false; # Disable editor for security
        consoleMode = "max"; # Set console mode to max resolution
        extraInstallCommands = "${pkgs.gnused}/bin/sed -i '/default/ s/.*/default arch-linux-zen.efi/' /boot/loader/loader.conf";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "nowatchdog" "mitigations=off" ]; # Enable amd_pstate, disable watchdog and mitigations (not needed on personal systems)
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "nct6775" ]; # add some modules to the initrd
    kernelPackages = pkgs.linuxKernel.packages.linux_zen; # Set kernel to linux_zen
    extraModulePackages = with config.boot.kernelPackages; [ zenpower xone ]; # Add xone package for Xbox Controller support
    blacklistedKernelModules = [ "k10temp" ]; # Blacklist k10temp because zenpower provides it
    tmp.useTmpfs = true;
  };

  hardware.xone.enable = true; # Enable xone module

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    earlySetup = true; # Load font ASAP on boot (initrd)
    font = "ter-i28b"; # HiDPI font for 1440p Display
    packages = with pkgs; [ terminus_font ]; # Add terminus_font package
  };

  # Set a percentage of RAM to zstd compressed swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
