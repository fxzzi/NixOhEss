{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.lact;
in {
  options.cfg.services.lact.enable = mkEnableOption "lact";
  config = mkIf cfg.enable {
    services.lact = {
      enable = true;
      # FIXME: currently overriding for newer version, which has support for
      # nvidia vf curve.
      package = pkgs.lact.overrideAttrs (oldAttrs: rec {
        version = "0.9.0";
        src = pkgs.fetchFromGitHub {
          owner = "ilya-zlobintsev";
          repo = "LACT";
          tag = "v${version}";
          hash = "sha256-c5GJf8AYgaAN3O6AVSEbJybEYb6lSHf7R24/1PKYhyM=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-Y+XdCmaDXdP7x22bYm//Ov7+IzlCr8GpFOgCXGFCfbA=";
        };
        buildInputs = oldAttrs.buildInputs ++ [pkgs.libadwaita];
      });
    };
  };
}
