{pkgs, config, ...}: {
  home.packages = with pkgs; [
    nh
		nvd
		nix-output-monitor
  ];
	programs.zsh.shellAliases = {
		rb = "nh os switch ${config.xdg.configHome}/nixos";
		rbu = "nh os switch -u ${config.xdg.configHome}/nixos";
		rbb = "nh os boot ${config.xdg.configHome}/nixos";
	};
}
