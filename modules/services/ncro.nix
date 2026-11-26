{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  config = {
    services.ncro = {
      enable = true;
      settings = {
        logging = {
          format = "text";
          timestamps = false;
        };
        fallback_cache.enabled = true;
        upstreams = [
          {
            url = "https://cache.nixos.org";
            public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          }
          {
            url = "https://nix-community.cachix.org";
            public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          }
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
