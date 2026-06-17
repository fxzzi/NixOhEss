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
    mkDefault
    ;
in {
  options = {
    cfg.core = {
      isLaptop = mkEnableOption "laptop";
      keyLayout = mkOption {
        type = types.str;
        default = "us";
        description = "Sets the console keyboard layout";
      };
    };
  };
  config = {
    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
      packages = [pkgs.terminus_font];
      keyMap = config.cfg.core.keyLayout;
    };

    # default TZ
    time.timeZone = mkDefault "Europe/London";
    # default locale
    i18n.defaultLocale = mkDefault "en_GB.UTF-8";

    boot = {
      kernelParams = [
        "fbcon=font:TER16x32" # make font size bigger
        "nowatchdog" # unsafe!! but fine for personal computers
        "mitigations=off" # also unsafe!!
      ];
      # disable some more watchdog
      extraModprobeConfig = ''
        blacklist sp5100_tco
      '';
    };
  };
}
