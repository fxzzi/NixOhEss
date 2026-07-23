{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe mkForce;
  inherit (pkgs) writeText runCommand stash-clipboard;
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
    # FIXME: remove when merged
    # https://github.com/NixOS/nixpkgs/pull/542997
    environment.systemPackages = [
      (runCommand "stash-symlinks" {} ''
        mkdir -p $out/bin
        for bin in stash-copy stash-paste wl-copy wl-paste; do
          ln -s ${getExe stash-clipboard} $out/bin/$bin
        done
      '')
    ];
    # systemd.user.services.stash-clipboard.serviceConfig.ExecStart = mkForce "${getExe stash-clipboard} --max-items 10 watch --persist";
  };
}
