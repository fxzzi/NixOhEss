{
  inputs,
  user,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  environment.systemPackages = [pkgs.sops];
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${user}/.local/share/ssh/age/sops.txt";

    secrets = {
      "mediamtx/localip" = {};
    };
  };
}
