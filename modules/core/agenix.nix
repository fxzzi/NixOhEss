{
  inputs,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
  imports = [inputs.agenix.nixosModules.default];
  age.identityPaths = ["${config.hj.xdg.dataDirectory}/ssh/agenix"];
}
