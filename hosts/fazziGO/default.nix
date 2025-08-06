{
  pkgs,
  npins,
  ...
}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  hj = {
    packages = with pkgs; [
      telegram-desktop
      qpwgraph
    ];
    xdg.config.files."hypr/hyprland.conf" = {
      value = {
        decoration = {
          shadow.enabled = 0;
          blur.enabled = 0;
        };
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # i don't use bluetooth much so disable it by default
  };
  services = {
    blueman.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn; # mullvad gui
      enableExcludeWrapper = false; # i do not use the wrapper
    };
  };
}
