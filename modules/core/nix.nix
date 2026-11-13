{
  inputs,
  pkgs,
  ...
}:
{
  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      channel.enable = false; # we use le flakes
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        azzipkgs.flake = inputs.azzipkgs;
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
        ];
        auto-optimise-store = true; # save some storage space
        warn-dirty = false;
        allow-import-from-derivation = false; # don't allow IFD, they're slow asf
        use-xdg-base-directories = true; # clean up ~
        allowed-users = [ "@wheel" ];
        trusted-users = [ "@wheel" ];
        flake-registry = "";
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
