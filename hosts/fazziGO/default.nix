{pkgs, ...}: {
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
        # helps on laptops
        render.new_render_scheduling = true;
      };
    };
  };
}
