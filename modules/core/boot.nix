{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkDefault
    ;
  cfg = config.cfg.core.boot;
in {
  options.cfg.core.boot = {
    enable = mkEnableOption "boot";
    keyLayout = mkOption {
      type = types.str;
      default = "us";
      description = "Sets the keyboard layout for ttys";
    };
    timeout = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Sets the timeout for the boot menu to automatically continue.
        If set to 0, the boot menu will be hidden unless space is spammed during boot.
      '';
    };
  };
  config = mkIf cfg.enable {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = [pkgs.terminus_font];
      keyMap = cfg.keyLayout;
    };

    system.nixos.distroName = "NixOhEss";
    environment.etc.issue = {
      # a disgusting mess of escape codes to make it look nice. extra line on purpose for spacing.
      source = pkgs.writeText "issue" ''
        \e[32mWelcome to the fold of ${config.system.nixos.distroName}, \e[36m${config.cfg.core.username}\e[1;32m. \e[2m(\l)\e[0m

      '';
    };

    # Set your time zone.
    time.timeZone = mkDefault "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = mkDefault "en_GB.UTF-8";

    # Set a percentage of RAM to zstd compressed swap
    zramSwap = {
      enable = true;
      memoryPercent = 50;
      # in bytes
      memoryMax = 8 * 1024 * 1024 * 1024;
    };
    boot = {
      initrd.systemd.enable = true;
      loader = {
        inherit (cfg) timeout;
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
      # zram is fast enough that we can be aggressive with swappiness
      kernel.sysctl."vm.swappiness" = 130;
      kernel.sysctl."kernel.sysrq" = 1; # enable sysrq / reisub
    };
  };
}
