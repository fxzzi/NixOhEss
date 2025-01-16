_: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      use-xdg-base-directories = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };
  };
  nixpkgs.config.allowUnfree = true;
  documentation.nixos.enable = false;
}
