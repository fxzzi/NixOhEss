{ config, pkgs, ... }: 
{
  nixpkgs.config.allowUnfree = true; # Allow installing of Unfree software, mostly nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    nvidia = {
      open = true; # Set to false until wake-up from suspend is fixed
      modesetting.enable = true; # Enable modesetting in nvidia for nvidia-vaapi-driver
      powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
      package = config.boot.kernelPackages.nvidiaPackages.beta; # Use beta drivers
      nvidiaSettings = false; # Disable nvidia-settings applet, useless on Wayland
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-utils
        nvidia-vaapi-driver
      ];
    };
  };
}
