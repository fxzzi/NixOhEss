{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mapAttrsToList;
  inherit (builtins) mapAttrs;
in {
  config = {
    nix = {
      # use lix, bcuz its faster i guess
      package = pkgs.lixPackageSets.latest.lix;
      # Disable channels and add the inputs to the registry
      channel.enable = false;
      registry = mapAttrs (_: flake: {inherit flake;}) inputs;
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
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
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];
        build-dir = "/var/tmp";
        # Disable channels and add the inputs to the registry
        nix-path = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
        flake-registry = "";
      };
    };
    nixpkgs.config.allowUnfree = true; # not too fussed as long as app works on linux tbh
    documentation.nixos.enable = false; # remove useless docs .desktop

    # don't build stuff on tmpfs, it can easily run out of space
    systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };
  };
}
