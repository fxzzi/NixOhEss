{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.ssh;
in {
  options.cfg.programs.ssh.enable = mkEnableOption "ssh";
  config = mkIf cfg.enable {
    programs.ssh = {
      extraConfig = ''
        # GitHub
        Host github.com
        	Hostname github.com
        	IdentityFile /home/${config.cfg.core.username}/.ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile /home/${config.cfg.core.username}/.ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile /home/${config.cfg.core.username}/.ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile /home/${config.cfg.core.username}/.ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile /home/${config.cfg.core.username}/.ssh/codeberg
      '';
    };
  };
}
