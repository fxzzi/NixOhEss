{pkgs, ...}: {
  config = {
    nix = {
      # use lix, bcuz its faster i guess
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
