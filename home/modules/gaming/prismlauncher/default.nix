{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.prismlauncher.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable gaming packages and configuration.";
  };

  config = lib.mkIf config.cfg.gaming.prismlauncher.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          temurin-jre-bin-8
          temurin-jre-bin-17
          temurin-jre-bin-21
        ];
      })
    ];
  };
}
