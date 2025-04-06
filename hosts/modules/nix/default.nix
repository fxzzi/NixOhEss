{
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
    channel.enable = false; # we don't like imperative stuff here.
  };
  nixpkgs.config.allowUnfree = true; # not too fussed as long as app works on linux tbh
  documentation.nixos.enable = false; # remove useless docs .desktop
}
