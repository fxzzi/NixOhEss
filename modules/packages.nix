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
    ripgrep
    gcc
    ffmpeg
    zenmonitor
    xdg-utils
    jq
    killall
  ];
}
