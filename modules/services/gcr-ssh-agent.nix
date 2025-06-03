{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs-gcr}/nixos/modules/services/desktops/gnome/gcr-ssh-agent.nix"
  ];
  config = {
    services.gnome.gcr-ssh-agent = {
      enable = true;
      package = inputs.nixpkgs-gcr.legacyPackages.${pkgs.system}.gcr_4;
    };
  };
}
