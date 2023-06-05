{ config, pkgs, ... }: 
{
  boot = {
    loader = {
      timeout = 6; # Timeout before launching default entry
      systemd-boot = {  
        enable = true; # Enable systemd-boot
        editor = false; # Disable editor for security
        consoleMode = "0"; # Set console mode to max resolution
        extraEntries = { "arch.conf" = ''
                         title Arch Linux
                         linux /vmlinuz-linux-zen
                         initrd /amd-ucode.img
                         initrd /booster-linux-zen.img
                         options root=UUID=0e488fe7-cc5a-44c3-8289-588a02ff9dcc rootflags=subvol=@ rw quiet loglevel=3 nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_UsePageAttributeTable=1 zswap.enabled=0 amd_pstate=active nowatchdog mitigations=off
                         '';};
        extraInstallCommands = "sed -i '/default/ s/.*/default arch.conf/' /boot/loader/loader.conf";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "amd_pstate=active" "nowatchdog" "mitigations=off" ]; # Enable amd_pstate, disable watchdog and mitigations (not needed on personal systems)
    kernelModules = [ "nvidia nvidia_modeset nvidia_uvm nvidia_drm" ]; # Enable nvidia modules for early KMS
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
#  console = {
#    earlySetup = true; # Load font ASAP on boot (initrd)
#    font = "ter-i28b"; # HiDPI font for 1440p Display
#    packages = with pkgs; [terminus_font]; # Add terminus_font package
#  };

  # Set 25% of RAM to zstd compressed swap
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };
}
