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
        	IdentityFile ${config.hj.directory}/.ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile ${config.hj.directory}/.ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile ${config.hj.directory}/.ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile ${config.hj.directory}/.ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile ${config.hj.directory}/.ssh/codeberg
      '';
    };
  };
}
