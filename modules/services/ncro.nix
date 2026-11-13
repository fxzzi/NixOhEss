{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (builtins) toString;

  cache-nixos-org = {
    url = "https://cache.nixos.org";
    public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
  };
in
{
  imports = [
    "${inputs.ncro}/nix/module.nix"
  ];
  config = {
    services.ncro = {
      enable = true;
      port = 49152;
      settings = {
        logging = {
          format = "text";
          timestamps = false;
        };
        fallback_cache = {
          # thanks clementine
          enabled = true;
          inherit (cache-nixos-org) url public_key;
        };
        upstreams = [
          cache-nixos-org
          {
            url = "https://cache.manic.systems";
            public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
          }
          {
            url = "https://cache.nixos-cuda.org";
            public_key = "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";
          }
          {
            url = "https://hyprland.cachix.org";
            public_key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
          }
        ];
      };
    };
    # override the default nixos-cache substituter as well
    nix.settings.substituters = mkForce [ "http://localhost:${toString config.services.ncro.port}" ];
  };
}
