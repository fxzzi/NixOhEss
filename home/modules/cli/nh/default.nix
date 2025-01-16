{
  config,
  lib,
  ...
}: {
  options.cli.nh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables nh with some shell aliases, and daily gc.";
  };
  config = lib.mkIf config.cli.nh.enable {
    programs = {
      nh = {
        enable = true;
        flake = "${config.xdg.configHome}/nixos";
        clean = {
          enable = true;
          dates = "daily";
          extraArgs = "--keep 8 --keep-since 4d";
        };
      };

      zsh.shellAliases = {
        rb = "nh os switch";
        rbu = "nh os switch -u";
        rbb = "nh os boot";
        rbbu = "nh os boot -u";
      };
    };
  };
}
