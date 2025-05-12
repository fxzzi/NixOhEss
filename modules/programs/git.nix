{
  config,
  lib,
  ...
}: {
  options.cfg.cli.git = {
    enable = lib.mkEnableOption "git";
    name = lib.mkOption {
      type = lib.types.str;
      default = false;
      description = "Sets your username for git.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = false;
      description = "Sets your email for git.";
    };
  };
  config = lib.mkIf config.cfg.cli.git.enable {
    environment.shellAliases = {
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gb = "git branch";
      gc = "git commit --verbose";
      gcam = "git commit --all --message";
      gd = "git diff";
      gp = "git push";
    };
    programs.git = {
      enable = true;
      config = {
        user = {
          inherit (config.cfg.cli.git) name;
          inherit (config.cfg.cli.git) email;
        };
        signing = {
          format = "ssh";
        };
      };
    };
  };
}
