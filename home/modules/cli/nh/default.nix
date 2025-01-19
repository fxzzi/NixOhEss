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
          dates = "*-*-* 00/6:00:00";
          extraArgs = "--keep 8";
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
