{pkgs, ...}: {
  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      channel.enable = false; # we use le flakes
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true; # save some storage space
        warn-dirty = false;
        allow-import-from-derivation = false; # don't allow IFD, they're slow asf
        use-xdg-base-directories = true; # clean up ~
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];
        flake-registry = "";
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://hyprland.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };
    nixpkgs.config = {
      allowUnfree = true; # not too fussed as long as app works on linux tbh
    };

    # remove useless docs .desktop
    documentation.nixos.enable = false;

    # thanks raf!
    # <https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/nix/module.nix#L236>
    systemd.services = {
      nix-gc = {
        unitConfig.ConditionACPower = true;
      };
      nh-clean = {
        unitConfig.ConditionACPower = true;
      };
    };
  };
}
