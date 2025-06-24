{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.bootConfig = {
    enable = lib.mkEnableOption "boot";
    keyLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Sets the keyboard layout for ttys";
    };
    timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = ''
        Sets the timeout for the boot menu to automatically continue.
        If set to 0, the boot menu will be hidden unless space is spammed during boot.
      '';
    };
  };
  imports = [
    ./secureboot.nix
    ./greetd.nix
    ./tty1SkipUsername.nix
  ];
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
        inherit (config.cfg.bootConfig) timeout;
        systemd-boot = {
          enable = true; # Enable systemd-boot
          configurationLimit = 5; # shouldn't really need any more than that.
          editor = false; # Disable editor for security
          consoleMode = "max"; # Set console mode to max resolution
        };
        efi.canTouchEfiVariables = true;
      };
      kernelParams = [
        "nowatchdog" # unsafe!! but fine for desktops
        "mitigations=off" # also unsafe!!
        "fbcon=font:TER16x32" # make font size bigger
      ];
      tmp = {
        useTmpfs = true; # /tmp is not on tmpfs by default (why??)
        tmpfsSize = "50%"; # allow it to use x% of your RAM
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
