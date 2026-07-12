{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (pkgs) writeText stash-clipboard;
  cfg = config.cfg.services.stash;
  regex = "(password|secret|api[_-]?key|token)[=: ]+[^\s]+";
in {
  options.cfg.services.stash.enable = mkEnableOption "stash";
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommand "stash-symlinks" {} ''
        mkdir -p $out/bin
        for bin in stash-copy stash-paste wl-copy wl-paste; do
          ln -s ${getExe stash-clipboard} $out/bin/$bin
        done
      '')
    ];
    services.stash-clipboard = {
      enable = true;
      arguments = ["--max-items 10"];
      filterFile = "${writeText "stash-regex" regex}";
    };
  };
}
