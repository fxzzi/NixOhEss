{lib, ...}: let
  inherit (lib) mkDefault mkEnableOption;
in {
  imports = [
    ./fastfetch
    ./android.nix
    ./bash.nix
    ./bottom.nix
    ./git.nix
    ./ncmpcpp.nix
    ./nh.nix
    ./nvf.nix
    ./ssh.nix
    ./zsh.nix
    ./hyprland
    ./hyprlock.nix
    ./wleave
    ./fuzzel.nix
    ./librewolf
    ./chromium
    ./startpage.nix
    ./foot.nix
    ./mpv.nix
    ./obs-studio.nix
    ./thunar.nix
    ./discord.nix
    ./ags
    ./sudo.nix
    ./heroic.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./eden.nix
    ./steam.nix
    ./proton.nix
    ./osu.nix
    ./gamescope.nix
    ./scripts
    ./wallust
  ];
  options.cfg.programs.smoothScroll = {
    enable = mkEnableOption "smooth scrolling" // {default = true;};
  };
  config = {
    # nano is enabled by default. no.
    # also dont install any of the default packages.
    # cmd-not-found is useless
    programs.nano.enable = mkDefault false;
    environment.defaultPackages = mkDefault [];
    programs.command-not-found.enable = false;
  };
}
