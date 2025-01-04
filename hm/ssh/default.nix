{ pkgs, ... }:
{
	programs.ssh = {
		enable = true;
		addKeysToAgent = "yes";
		hashKnownHosts = true;
		extraConfig = ''
# GitHub
Host github.com
	Hostname github.com
	IdentityFile ~/.ssh/github

# GitLab
Host gitlab.com
	Hostname gitlab.com
	IdentityFile ~/.ssh/gitlab

# ArchLinux GitLab
Host https://gitlab.archlinux.org
	Hostname https://gitlab.archlinux.org/
	IdentityFile ~/.ssh/archlinux-gitlab

# AUR
Host aur.archlinux.org
	Hostname aur.archlinux.org
	IdentityFile ~/.ssh/aur

# Codeberg
Host codeberg.org
	Hostname codeberg.org
	IdentityFile ~/.ssh/codeberg
	'';
	};
	programs.git = {
		enable = true;
		userName = "Fazzi";
		userEmail = "faaris.ansari@proton.me";
	};
	services.ssh-agent.enable = true;
	home.sessionVariables = { SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"; };
}
