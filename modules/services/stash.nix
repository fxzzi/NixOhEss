{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.stash;
in
{
  options.cfg.services.stash.enable = mkEnableOption "stash";
  config = mkIf cfg.enable {
    # provides wl-copy/wl-paste too
    services.stash-clipboard = {
      enable = true;
      arguments = [
        "--max-items 24"
        "--min-size 2"
      ];
    };
  };
}
