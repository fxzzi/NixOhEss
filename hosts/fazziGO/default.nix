{
  pkgs,
  inputs,
  ...
}: let
  fazziPC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhE7wYZ6juPg1uPs8hTJJMjzWVlMB4maX2K7rE9X84I agenix";
in {
  config = {
    system.stateVersion = "25.05";
    hj = {
      packages = with pkgs; [
        deluge
        inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.losange
        # (jetbrains.idea-oss.override {
        #   vmopts = "-Dawt.toolkit.name=WLToolkit";
        # })
      ];
    };
    cfg.programs.hyprland.config = {
      render = {
        # sidestep all cm issues by just disabling it
        cm_enabled = 0;
      };
    };
    boot.loader.limine.secureBoot.enable = true;
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    users.users.root.openssh.authorizedKeys.keys = [fazziPC];
    users.users.faaris.openssh.authorizedKeys.keys = [fazziPC];
    # set these when travelling
    # services = {
    #   geoclue2.enable = true;
    #   localtimed.enable = true;
    # };
  };
}
