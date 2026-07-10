{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) writeText;
  cfg = config.cfg.services.stash;
  regex = "(password|secret|api[_-]?key|token)[=: ]+[^\s]+";
in {
  options.cfg.services.stash.enable = mkEnableOption "stash";
  config = mkIf cfg.enable {
    services.stash-clipboard = {
      enable = true;
      arguments = ["--max-items 10"];
      filterFile = "${writeText "stash-regex" regex}";
    };
  };
}
