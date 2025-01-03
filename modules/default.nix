{ config, pkgs, lib, ... }:

let
  # Import other module files
  modules = [
    ./audio.nix
    ./boot.nix
    ./cachix.nix
    ./fancontrol.nix
    ./fonts.nix
    ./gaming.nix
    ./networking.nix
    ./nvidia.nix
    ./packages.nix
    ./services.nix
    ./state.nix
    ./user.nix
    ./wayland.nix
    ./getty-tty1-only-password.nix
  ];

in
{
  # Include all the modules in the NixOS system configuration
  imports = modules;
}
