{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
    lutris
    gamemode
		gamescope
    mangohud
		heroic
  ];

}
