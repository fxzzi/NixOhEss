{ pkgs, ... }:

{
  # can't symlink the entire dir to be in nix store,
  # because of lazy-lock.json. maybe some other day :]
  home.file.".config/nvim/init.lua".source = "${./nvim/init.lua}";
  home.file.".config/nvim/lua".source = "${./nvim/lua}";

  programs.neovim = {
    enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
    extraPackages = with pkgs; [
      bash-language-server
      vscode-langservers-extracted
      lua-language-server
      markdownlint-cli
      mdformat
      nil
      nixpkgs-fmt
      nodePackages_latest.prettier
      shfmt
      typescript-language-server
    ];
		extraPython3Packages = ps: with ps; [
			python-lsp-server
		];
  };
}

