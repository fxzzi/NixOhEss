{ ... }:

let
  # Import other module files
  modules = [
    ./audio.nix
    ./boot.nix
    ./cachix.nix
    ./fancontrol.nix
    ./fonts.nix
    ./networking.nix
    ./nvidia.nix
    ./packages.nix
    ./services.nix
    ./state.nix
    ./user.nix
    ./wayland.nix
		./opentabletdriver.nix
    # ./getty-tty1-only-password.nix
  ];

in
{
  imports = modules;
}
