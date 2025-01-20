{
  pkgs,
  config,
  ...
}: {
  home = {
    stateVersion = "24.11"; # Match your NixOS release or Home Manager version

    sessionVariables = {
      # Set other tool and configuration paths to clean up ~
      GOPATH = "${config.xdg.dataHome}/go";
      CARGO_HOME = "${config.xdg.dataHome}/cargo"; # Cargo package manager
      GNUPGHOME = "${config.xdg.dataHome}/gnupg"; # GNU Privacy Guard home
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dawt.useSystemAAFontSettings=gasp"; # Java preferences
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      ANDROID_HOME = "${config.xdg.dataHome}/android"; # Android SDK home
    };
    sessionPath = [
      # if you ever need to add dirs to $PATH,
      # add them here!
    ];
    packages = with pkgs; [
      vesktop
      wget
      python3
      ffmpeg
      pwvucontrol
      mate.atril
      mate.eom
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.en_GB-ise
      npins
      yt-dlp
      xournalpp
    ];
  };

  imports = [
    ./cli
    ./gui
    ./scripts
    ./xdg
    ./music
    ./gaming
    ./apps
  ];
}
