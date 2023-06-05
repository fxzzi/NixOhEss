{ config, pkgs, ... }: 
{
  # List services that you want to enable:
  services = {
    printing.enable = true;
    tumbler.enable = true; # Thunar thumbnailer
    flatpak.enable = true; # Enables flatpak for packages which aren't available through nix
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
    gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
  };

  security.polkit.enable = true; # Enable polkit for root access in GUI apps
  security.rtkit.enable = true; # Enable RTKit service for Pipewire priority
  security.pam.services.faaris.enableGnomeKeyring = true; # Enable gnome keyring for user
  systemd = {
    user.services.polkit-mate-authentication-agent-1 = {
      description = "polkit-mate-authentication-agent-1";
      wantedBy = [ "xdg-desktop-portal-hyprland.service" ];
      wants = [ "xdg-desktop-portal-hyprland.service" ];
      after = [ "xdg-desktop-portal-hyprland.service" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };
}
