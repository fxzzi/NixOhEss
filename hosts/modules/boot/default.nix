{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bootConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Setup systemd boot and a few initial boot options";
  };
  options.bootConfig.keyLayout = lib.mkOption {
    type = lib.types.str;
    default = "us";
    description = "Sets the keyboard layout for ttys";
  };
  imports = [./secureboot];
  config = lib.mkIf config.bootConfig.enable {
    boot = {
      loader = {
        timeout = 3; # Timeout before launching default entry
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
      ]; # disable watchdog and mitigations (not needed on personal systems)
      tmp.useTmpfs = true; # /tmp is not on tmpfs by default (why??)
      tmp.tmpfsSize = "50%";
      extraModprobeConfig = ''
        blacklist sp5100_tco
      '';
    };
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = with pkgs; [terminus_font];
      keyMap = config.bootConfig.keyLayout;
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
  };
}
