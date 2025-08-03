{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.prismlauncher;
in {
  options.cfg.programs.prismlauncher.enable = mkEnableOption "prismlauncher";

  config = mkIf cfg.enable {
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
