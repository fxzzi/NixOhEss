{
  pkgs,
  inputs,
  ...
}: {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        telegram-desktop
        deluge
        inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell-rewrite-git
        (jetbrains.idea-oss.override {
          vmopts = "-Dawt.toolkit.name=WLToolkit";
        })
      ];
      xdg.config.files."hypr/hyprland.conf" = {
        value = {
          decoration = {
            # muh battery
            blur.enabled = 0;
          };
          render = {
            # sidestep all cm issues by just disabling it
            cm_enabled = 0;
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
