{
  pkgs,
  inputs',
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./options.nix
    ./secureboot.nix
  ];
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        telegram-desktop
        deluge
        inputs'.azzipkgs.packages.stremio-linux-shell-rewrite-git
        (jetbrains.idea-oss.override {
          vmopts = "-Dawt.toolkit.name=WLToolkit";
        })
      ];
      xdg.config.files."hypr/hyprland.conf" = {
        value = {
          decoration = {
            # muh battery
            shadow.enabled = 0;
            blur.enabled = 0;
          };
        };
      };
    };
    # set these when travelling
    # services = {
    #   geoclue2.enable = true;
    #   localtimed.enable = true;
    # };
  };
}
