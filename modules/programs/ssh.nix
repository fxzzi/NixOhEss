{
  config,
  lib,
  user,
  pkgs,
  ...
}: {
  options.cfg.cli.ssh.enable = lib.mkEnableOption "ssh";
  config = lib.mkIf config.cfg.cli.ssh.enable {
    programs.ssh = {
      extraConfig = ''
        # GitHub
        Host github.com
        	Hostname github.com
        	IdentityFile /home/${user}/.local/share/ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile /home/${user}/.local/share/ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile /home/${user}/.local/share/ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile /home/${user}/.local/share/ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile /home/${user}/.local/share/ssh/codeberg
      '';
    };
    systemd.user.services.gnome-keyring = {
      enable = true;
      description = "GNOME Keyring";
      partOf = ["graphical-session-pre.target"];
      wantedBy = ["graphical-session-pre.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-abort";
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh";
      };
    };

    environment.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    };
  };
}
