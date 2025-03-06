{
  config,
  lib,
  ...
}: {
  options.cfg.cli.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables my git configurations.";
  };
  config = lib.mkIf config.cfg.cli.git.enable {
    programs.git = {
      enable = true;
      userName = "Fazzi";
      userEmail = "faaris.ansari@proton.me";
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
