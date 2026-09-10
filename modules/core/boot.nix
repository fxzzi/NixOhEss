{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkDefault
    mkIf
    ;
in
{
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
      packages = [ pkgs.terminus_font ];
      keyMap = config.cfg.core.keyLayout;
    };

    time.timeZone = mkDefault "Europe/London";
    i18n.defaultLocale = mkDefault "en_GB.UTF-8";

    boot = {
      kernelParams = [
        # we set the font above to a larger one, but the font will still
        # be small early in boot. This param will set it even earlier.
        "fbcon=font:TER16x32"
        # disable watchdog lockup detection, improves performance slightly
        "nowatchdog"
        # disable spectre, meltdown, etc mitigations for performance at
        # the cost of security. i don't think mossad is after me YET
        "mitigations=off"
        # enable dynamic epp for laptops. this will change the epp
        # based on the charging / discharging status.
        (mkIf config.cfg.core.isLaptop "amd_pstate.dynamic_epp=1")
      ];
      # disable hardware watchdog present on my laptop
      extraModprobeConfig = ''
        blacklist sp5100_tco
      '';
    };
  };
}
