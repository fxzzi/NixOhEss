{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        telegram-desktop
        customPkgs.stremio-enhanced
        # ide for uni
        processing
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
    # set these when travelling
    services = {
      geoclue2.enable = true;
      localtimed.enable = true;
    };
  };
}
