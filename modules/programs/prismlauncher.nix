{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.programs.prismlauncher.enable = lib.mkEnableOption "prismlauncher";

  config = lib.mkIf config.cfg.programs.prismlauncher.enable {
    hj = {
      packages = with pkgs; [
        (prismlauncher.override {
          jdks = [
            temurin-jre-bin-8
            temurin-jre-bin-17
            temurin-jre-bin-21
          ];
        })
      ];
    };
  };
}
