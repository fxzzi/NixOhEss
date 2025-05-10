{pkgs, ...}: {
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true; # save some storage space
      warn-dirty = false;
      use-xdg-base-directories = true; # clean up ~
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };
  };
  nixpkgs.config.allowUnfree = true; # not too fussed as long as app works on linux tbh
  documentation.nixos.enable = false; # remove useless docs .desktop
  system.rebuild.enableNg = true; # use python based nixos-rebuild
}
