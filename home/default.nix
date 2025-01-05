{ config, pkgs, ... }: {
  home.username = "faaris";
  home.homeDirectory = "/home/faaris";
  home.stateVersion =
    "24.11"; # Match your NixOS release or Home Manager version

  home.sessionVariables = {
    # Set other tool and configuration paths to clean up ~
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.dataHome}/cargo"; # Cargo package manager
    GNUPGHOME = "${config.xdg.dataHome}/gnupg"; # GNU Privacy Guard home
    _JAVA_OPTIONS =
      "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dawt.useSystemAAFontSettings=gasp"; # Java preferences
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    ANDROID_HOME = "${config.xdg.dataHome}/android"; # Android SDK home
  };
  home.sessionPath = [
    # if you ever need to add dirs to $PATH,
    # add them here!
  ];

  imports = [ ./browsers ./cli ./gui ./extra ./scripts ./xdg ./media ];
  home.packages = with pkgs; [ vesktop wget python3 fzf ffmpeg ];
}

