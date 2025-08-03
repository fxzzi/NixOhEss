{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.services.gcr-ssh-agent.enable = lib.mkEnableOption "gcr-ssh-agent";
  config = lib.mkIf config.cfg.services.gcr-ssh-agent.enable {
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
