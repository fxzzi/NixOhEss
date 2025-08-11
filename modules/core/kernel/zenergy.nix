{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) fetchpatch;
  cfg = config.cfg.core.kernel.zenergy;
in {
  options.cfg.core.kernel.zenergy.enable = mkEnableOption "zenergy";
  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["nct6775"]; # provides temp readings
      # extraModulePackages = with config.boot.kernelPackages; [zenergy]; # provides power readings
      # FIXME: remove when zenergy is updated to support 6.16
      extraModulePackages = [
        (config.boot.kernelPackages.zenergy.overrideAttrs
          (old: {
            patches =
              (old.patches or [])
              ++ [
                (fetchpatch {
                  url = "https://github.com/BoukeHaarsma23/zenergy/pull/18.patch";
                  hash = "sha256-Xe6CaiU9Vcxxgzu4VGrriq5sAQfymFbsw4kEf3Gj2C0=";
                })
              ];
          }))
      ];
    };
  };
}
