{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    python3
    fzf
    lm_sensors
    gnumake
    nodejs
    cargo
    fd
    gcc
    ffmpeg
    zenmonitor
    xdg-utils
    jq
    killall
    rnnoise-plugin
    npins
  ];
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config.credential.helper = "libsecret";
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
