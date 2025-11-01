{
  self,
  pkgs,
  config,
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
        self.packages.${pkgs.stdenv.hostPlatform.system}.stremio-enhanced
        # uni stuff
        processing
        logisim-evolution
        vscodium
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
