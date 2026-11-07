{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.gcr-ssh-agent;
in
{
  options.cfg.services.gcr-ssh-agent.enable = mkEnableOption "gcr-ssh-agent";
  config = mkIf cfg.enable {
    services.gnome.gcr-ssh-agent.enable = true;
    programs = {
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };
    environment.extraInit = # sh
      ''
        if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
        fi
      '';
  };
}
