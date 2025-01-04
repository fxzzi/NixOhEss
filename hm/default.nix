{ config, ... }:
{

  home.username = "faaris";
  home.homeDirectory = "/home/faaris";
  home.stateVersion = "24.11"; # Match your NixOS release or Home Manager version

  home.sessionVariables = {
    # XDG_CONFIG_HOME = "${config.xdg.configHome}"; # User configuration files
    # XDG_CACHE_HOME = "${config.xdg.cacheHome}"; # User cache files
    # XDG_DATA_HOME = "${config.xdg.dataHome}"; # User data files
    # XDG_STATE_HOME = "${config.xdg.stateHome}"; # User state files

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
    ./zsh.nix
		./xdg.nix
    ./fastfetch/default.nix
    ./hyprland/default.nix
		./obs-studio.nix
		./thunar.nix
		./transitioning/default.nix
  ];
}

