{
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = {
      GNUPGHOME = "${config.xdg.dataHome}/gnupg"; # GNU Privacy Guard home
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java -Dawt.useSystemAAFontSettings=gasp"; # Java preferences
    };
    packages = with pkgs; [
      wget
      python3
      ffmpeg
      pwvucontrol
      mate.atril
      mate.eom
      libreoffice
      hunspell
      hunspellDicts.en_GB-ise
      npins
      yt-dlp
      xournalpp
      stremio
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
