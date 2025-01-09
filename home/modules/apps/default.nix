{pkgs, ...}: {
  home.packages = with pkgs; [
    nheko
  ];

  imports = [
    ./browsers
    ./obs-studio
    ./mpv
    ./thunar
  ];
}
