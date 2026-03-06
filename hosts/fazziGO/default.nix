{pkgs, ...}: {
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
        stremio-linux-shell
        # uni stuff
        onlyoffice-desktopeditors
        processing
        logisim-evolution
        rars
        vscodium
        (jetbrains.idea-oss.override {
          vmopts = "-Dawt.toolkit.name=WLToolkit";
        })
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
    # set these when travelling
    # services = {
    #   geoclue2.enable = true;
    #   localtimed.enable = true;
    # };
  };
}
