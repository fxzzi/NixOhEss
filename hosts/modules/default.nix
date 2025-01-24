{pkgs, ...}: {
  imports = [
    ./gpu
    ./scx
    ./user
    ./audio
    ./fonts
    ./batmon
    ./cachix
    ./gaming
    ./kernel
    ./wayland
    ./services
    ./fancontrol
    ./networking
    ./boot
    ./opentabletdriver
    ./tty1-skipusername
    ./agenix
    ./nix
    ./home-manager
    ./adb
    ./security
  ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.sane-airscan];
}
