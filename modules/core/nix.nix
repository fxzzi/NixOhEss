{inputs, ...}: {
  imports = [
    # use determinate nix
    inputs.determinate.nixosModules.default
  ];
  config = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true; # save some storage space
        warn-dirty = false;
        use-xdg-base-directories = true; # clean up ~
        allow-import-from-derivation = false; # don't allow IFD, they're slow asf
        lazy-trees = true; # detsys nix only!!
        accept-flake-config = true; # allow cachix stuff
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];
        build-dir = "/var/tmp";
      };
    };
    nixpkgs.config.allowUnfree = true; # not too fussed as long as app works on linux tbh
    documentation.nixos.enable = false; # remove useless docs .desktop
    system.rebuild.enableNg = true; # use python based nixos-rebuild

    # don't build stuff on tmpfs, it can easily run out of space
    systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };
  };
}
