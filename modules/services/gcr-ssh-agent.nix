{pkgs, ...}: {
  config = {
    services.gnome.gcr-ssh-agent = {
      enable = true;
      package = pkgs.gcr_4;
    };
    programs = {
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };
  };
}
