{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.gcr-ssh-agent;
in {
  options.cfg.services.gcr-ssh-agent.enable = mkEnableOption "gcr-ssh-agent";
  config = mkIf cfg.enable {
    services.gnome.gcr-ssh-agent.enable = true;
    programs = {
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };
  };
}
