{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (pkgs) callPackage writeText;
  cfg = config.cfg.services.stash;
  stash = callPackage "${npins.stash}/nix/package.nix" {
    craneLib = callPackage "${npins.crane}/lib" {};
  };
  regex = "(password|secret|api[_-]?key|token)[=: ]+[^\s]+";
in {
  options.cfg.services.stash.enable = mkEnableOption "stash" // {default = true;};
  config = mkIf cfg.enable {
    hj.packages = [stash];
    systemd.user.services.stash = {
      enable = true;
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
        loadCredential = "clipboard_filter:${writeText "stash-regex" regex}";
      };
      serviceConfig = {
        ExecStart = "${getExe stash} --max-items 10 watch";
        Restart = "on-abort";
      };
    };
  };
}
