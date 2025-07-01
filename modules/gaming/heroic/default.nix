{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.heroic.enable = lib.mkEnableOption "heroic";
  config = lib.mkIf config.cfg.gaming.heroic.enable {
    hj = {
      packages = [
        (
          pkgs.heroic.override {
            heroic-unwrapped = pkgs.heroic-unwrapped.overrideAttrs (oldAttrs: {
              patches =
                oldAttrs.patches or []
                ++ [
                  ./0001-launch-with-window-wayland.patch
                ];
            });
          }
        )
      ];

      files = {
        ".config/heroic/tools/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
