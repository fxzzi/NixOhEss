{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mapAttrsToList;
  inherit (builtins) mapAttrs;
  nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
in {
  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      # Disable channels and add the inputs to the registry
      channel.enable = false;
      registry = mapAttrs (_: flake: {inherit flake;}) inputs;
      inherit nixPath;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true; # save some storage space
        warn-dirty = false;
        allow-import-from-derivation = false; # don't allow IFD, they're slow asf
        accept-flake-config = true; # allow using substituters from flake.nix
        use-xdg-base-directories = true; # clean up ~
        download-buffer-size = 500 * 1024 * 1024; # 500MiB. avoids warnings with full buffer
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];
        # Disable channels and add the inputs to the registry
        nix-path = nixPath;
        flake-registry = "";
        extra-substituters = [
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
          # cuda cache has a default priority of 30, set it to a
          # lower prio. regular nixpkgs cache has a priority of 40
          "https://cache.nixos-cuda.org?priority=41"
        ];
        extra-trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    };
    nixpkgs.config = {
      allowUnfree = true; # not too fussed as long as app works on linux tbh
      # these packages are marked as insecure but we still require them
      # permittedInsecurePackages = [
      #   "qtwebengine-5.15.19"
      #   "mbedtls-2.28.10"
      # ];
    };
    documentation.nixos.enable = false; # remove useless docs .desktop
  };
}
