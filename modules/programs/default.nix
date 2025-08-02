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
    ./obs-studio.nix
    ./thunar.nix
    ./discord.nix
    ./ags
    ./uwsm.nix
    ./sudo.nix
    ./heroic.nix
    ./lutris.nix
    ./mangohud
    ./prismlauncher.nix
    ./eden.nix
    ./steam.nix
    ./proton.nix
    ./osu.nix
    ./gamescope.nix
  ];
  config = {
    # nano is enabled by default. no.
    # also dont install any of the default packages.
    # cmd-not-found is useless
    programs.nano.enable = lib.mkDefault false;
    environment.defaultPackages = lib.mkDefault [];
    programs.command-not-found.enable = false;
  };
}
