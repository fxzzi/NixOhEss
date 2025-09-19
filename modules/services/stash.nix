{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (pkgs) writeText;
  stash = inputs.stash.packages.${pkgs.system}.default;
  cfg = config.cfg.services.stash;
  regex = "(password|secret|api[_-]?key|token)[=: ]+[^\s]+";
in {
  options.cfg.services.stash.enable = mkEnableOption "stash";
  config = mkIf cfg.enable {
    hj.packages = [stash];
    systemd.user.services.stash = {
      enable = true;
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${getExe stash} --max-items 10 watch";
        Restart = "on-abort";
        loadCredential = "clipboard_filter:${writeText "stash-regex" regex}";
      };
    };
    # hj.packages = [pkgs.stash];
    # services.stash-clipboard = {
    #   enable = true;
    #   flags = ["--max-items 10"];
    #   excludedApps = ["Bitwarden"];
    # };
  };
}
