{ config, pkgs,... }:
{

  home.username = "faaris";
  home.homeDirectory = "/home/faaris";
  home.stateVersion = "24.11"; # Match your NixOS release or Home Manager version

  home.sessionVariables = {
    # Set other tool and configuration paths to clean up ~
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.dataHome}/cargo"; # Cargo package manager
    GNUPGHOME = "${config.xdg.dataHome}/gnupg"; # GNU Privacy Guard home
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dawt.useSystemAAFontSettings=gasp"; # Java preferences
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    ANDROID_HOME = "${config.xdg.dataHome}/android"; # Android SDK home

    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh"; # Keyring
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/scripts"
    "${config.home.homeDirectory}/.local/bin"
    "${config.xdg.dataHome}/cargo/bin"
    "${config.xdg.dataHome}/go/bin"
	];

  imports = [
    ./zsh
		./xdg
    ./fastfetch
    ./hyprland
		./obs-studio
		./thunar
		./ags
		./foot
		./nvim
		./bottom
		./fuzzel
		./mpd
		./ncmpcpp
		./scripts
		./wleave
		./qtgtk
		./fonts
		./wallust
		./gaming
  ];
	home.packages = with pkgs; [
		vesktop
	];
}

