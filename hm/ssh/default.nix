{ ... }:
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
	services.ssh-agent.enable = true;
	services.gpg-agent = {
		enable = true;
		enableSshSupport = true;
		enableZshIntegration = true;
	};
	programs.git = {
		enable = true;
		userName = "Fazzi";
		userEmail = "faaris.ansari@proton.me";
	};
	services.gnome-keyring = {
		enable = true;
		components = [
			"pkcs11"
			"secrets"
			"ssh"
		];
	};
}
