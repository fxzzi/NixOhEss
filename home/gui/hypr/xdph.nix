{ pkgs, inputs, config, ... }: {
  home.packages = [
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  ];
  home.file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
    screencopy {
    	max_fps = 60
    }
  '';
}
