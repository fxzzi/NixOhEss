{
  config = {
    nix.settings = {
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://mitsuruu.cachix.org"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mitsuruu.cachix.org-1:c09hKovw2iXEEFzfoUhA5mzEEiGIF/N4wP5vxEyLD40="
      ];
    };
  };
}
