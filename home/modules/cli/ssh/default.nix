{
  config,
  lib,
  ...
}: {
  options.cfg.cli.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables my ssh configurations.";
  };
  config = lib.mkIf config.cfg.cli.ssh.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      hashKnownHosts = true;
      extraConfig = ''
        # GitHub
        Host github.com
        	Hostname github.com
        	IdentityFile ${config.xdg.dataHome}/ssh/github

        # GitLab
        Host gitlab.com
        	Hostname gitlab.com
        	IdentityFile ${config.xdg.dataHome}/ssh/gitlab

        # ArchLinux GitLab
        Host https://gitlab.archlinux.org
        	Hostname https://gitlab.archlinux.org/
        	IdentityFile ${config.xdg.dataHome}/ssh/archlinux-gitlab

        # AUR
        Host aur.archlinux.org
        	Hostname aur.archlinux.org
        	IdentityFile ${config.xdg.dataHome}/ssh/aur

        # Codeberg
        Host codeberg.org
        	Hostname codeberg.org
        	IdentityFile ${config.xdg.dataHome}/ssh/codeberg
      '';
    };
    services.gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets" "ssh"];
    };
    home.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    };
  };
}
