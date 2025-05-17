{lib, ...}: {
  imports = [
    ./fastfetch
    ./android.nix
    ./bash.nix
    ./bottom.nix
    ./git.nix
    ./ncmpcpp.nix
    ./nh.nix
    ./nvf.nix
    ./nvtop.nix
    ./ssh.nix
    ./zsh.nix
    ./theming
    ./hyprland
    ./hyprlock.nix
    ./wleave
    ./fuzzel.nix
    ./browsers
    ./foot.nix
    ./mpv.nix
    ./music.nix
    ./obs-studio.nix
    ./thunar.nix
    ./vesktop.nix
    ./ags
    ./uwsm
  ];
  config = {
    # nano is enabled by default. no.
    # also dont install any of the default packages.
    programs.nano.enable = lib.mkDefault false;
    environment.defaultPackages = lib.mkDefault [];
  };
}
