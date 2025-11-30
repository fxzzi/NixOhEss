{
  pkgs,
  config,
  self',
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        telegram-desktop
        deluge
        self'.packages.stremio-linux-shell
        # uni stuff
        onlyoffice-desktopeditors
        processing
        logisim-evolution
        rars
        vscodium
        (jetbrains.idea-community-bin.override {
          vmopts = "-Dawt.toolkit.name=WLToolkit";
        })
      ];
      xdg.config.files."hypr/hyprland.conf" = {
        value = {
          decoration = {
            shadow.enabled = 0;
            blur.enabled = 0;
          };
          # helps on laptops
          render.new_render_scheduling = true;
        };
      };
    };
    # encryption is enabled on fazziGO. So enter encryption
    # password and then autologin.
    services.getty = {
      autologinUser = config.cfg.core.username;
      autologinOnce = true;
    };
    # set these when travelling
    # services = {
    #   geoclue2.enable = true;
    #   localtimed.enable = true;
    # };
  };
}
