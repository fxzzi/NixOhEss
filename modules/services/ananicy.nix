{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.ananicy;
in {
  options.cfg.services.ananicy.enable = mkEnableOption "ananicy";
  config = mkIf cfg.enable {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp.overrideAttrs (oldAttrs: {
        # FIXME: remove when https://github.com/NixOS/nixpkgs/pull/552211 is merged
        patches =
          oldAttrs.patches or []
          ++ [
            (pkgs.fetchpatch {
              name = "fix-cstring-include.patch";
              url = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/merge_requests/43.diff";
              hash = "sha256-drBUVh+N3KedJttzQIIA1s+38ngK9BgZFOdpxqBWV0E=";
            })
          ];
      });
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
