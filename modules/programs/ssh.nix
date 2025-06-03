{
  config,
  lib,
  user,
  ...
}: {
  options.cfg.cli.ssh.enable = lib.mkEnableOption "ssh";
  config = lib.mkIf config.cfg.cli.ssh.enable {
    programs.ssh = {
      extraConfig = ''
        # GitHub
        Host github.com
        	Hostname github.com
        	IdentityFile /home/${user}/.ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile /home/${user}/.ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile /home/${user}/.ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile /home/${user}/.ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile /home/${user}/.ssh/codeberg
      '';
    };
  };
}
