{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/desktops/gnome/gcr-ssh-agent.nix"
  ];
  config = {
    services.gnome.gcr-ssh-agent = {
      enable = true;
      package = inputs.nixpkgs-master.legacyPackages.${pkgs.system}.gcr_4;
    };
    programs = {
      seahorse.enable = true;
      ssh.enableAskPassword = true;
    };
  };
}
