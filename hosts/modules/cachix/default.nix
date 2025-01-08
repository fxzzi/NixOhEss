{ lib, config, ... }:
{
  options.cachix.enable = lib.mkOption {
    type = lib.types.bool;
    # idk why you would disable cachix, so put this on true by default
    default = true;
    description = "Enables some predefined cachix servers";
  };
  config = lib.mkIf config.cachix.enable {
    nix.settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://nyx.cachix.org"
        "https://cache.m7.rs"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
        "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };
}
