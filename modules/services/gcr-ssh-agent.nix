{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.gcr-ssh-agent;
in {
  options.cfg.services.gcr-ssh-agent.enable = mkEnableOption "gcr-ssh-agent";
  config = mkIf cfg.enable {
    services.gnome.gcr-ssh-agent = {
      enable = true;
      package = pkgs.gcr_4;
    };
    programs = {
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };
  };
}
