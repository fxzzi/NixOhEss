{
  config,
  lib,
  ...
}: {
  options.cfg.cli.nh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables nh with some shell aliases.";
  };
  config = lib.mkIf config.cfg.cli.nh.enable {
    programs = {
      nh = {
        enable = true;
        flake = "${config.xdg.configHome}/nixos";
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d";
        };
      };

      zsh.shellAliases = {
        rb = "nh os switch";
        rbu = "nh os switch -u";
        rbb = "nh os boot";
        rbbu = "nh os boot -u";

        crb = "git -C $FLAKE fetch origin && git -C $FLAKE reset --hard origin/main && rb";
        crbb = "git -C $FLAKE fetch origin && git -C $FLAKE reset --hard origin/main && rbb";
      };
    };
  };
}
