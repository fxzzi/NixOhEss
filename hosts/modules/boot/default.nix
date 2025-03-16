{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.bootConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Setup systemd boot and a few initial boot options";
  };
  options.cfg.bootConfig.keyLayout = lib.mkOption {
    type = lib.types.str;
    default = "us";
    description = "Sets the keyboard layout for ttys";
  };
  imports = [./secureboot];
  config = lib.mkIf config.cfg.bootConfig.enable {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = with pkgs; [terminus_font];
      keyMap = config.cfg.bootConfig.keyLayout;
    };

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    # Set a percentage of RAM to zstd compressed swap
    zramSwap = {
      enable = true;
      memoryPercent = 50;
    };
    boot = {
      initrd.systemd.enable = true;
      loader = {
        timeout = 0; # hide boot menu, show if spamming space
        systemd-boot = {
          enable = true; # Enable systemd-boot
          editor = false; # Disable editor for security
          consoleMode = "max"; # Set console mode to max resolution
        };
        efi.canTouchEfiVariables = true;
      };
      kernelParams = [
        "nowatchdog"
        "mitigations=off"
        "fbcon=font:TER16x32"
      ];
      tmp = {
        useTmpfs = true; # /tmp is not on tmpfs by default (why??)
        tmpfsSize = "50%";
      };
      extraModprobeConfig = ''
        blacklist sp5100_tco
      '';
      # NOTE: https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
    };
  };
}
