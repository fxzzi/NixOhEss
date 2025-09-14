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
    ./steam.nix
    ./proton.nix
    ./osu.nix
    ./gamescope.nix
    ./wallust
  ];
  options.cfg.programs.smoothScroll = {
    enable = mkEnableOption "smooth scrolling" // {default = true;};
  };
  config = {
    programs = {
      # nano is enabled by default. no.
      # cmd-not-found is useless
      nano.enable = mkDefault false;
      command-not-found.enable = false;
    };
    # also dont install any of the default packages.
    environment.defaultPackages = mkDefault [];
  };
}
