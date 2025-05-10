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
        	IdentityFile ${config.hj.xdg.dataDirectory}/ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile ${config.hj.xdg.dataDirectory}/ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile ${config.hj.xdg.dataDirectory}/ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile ${config.hj.xdg.dataDirectory}/ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile ${config.hj.xdg.dataDirectory}/ssh/codeberg
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
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --components=pkcs11,secrets,ssh";
      };
    };

    environment.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    };
  };
}
