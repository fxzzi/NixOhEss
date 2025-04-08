{
  config,
  lib,
  ...
}: {
  options.cfg.cli.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables git configurations.";
    };
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
    programs.git = {
      enable = true;
      userName = config.cfg.cli.git.name;
      userEmail = config.cfg.cli.git.email;
      signing.format = "ssh";
    };
    programs.zsh.shellAliases = {
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gb = "git branch";
      gc = "git commit --verbose";
      gcam = "git commit --all --message";
      gd = "git diff";
      gp = "git push";
    };
  };
}
