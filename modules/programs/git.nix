{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.programs.git;
in {
  options.cfg.programs.git = {
    enable = mkEnableOption "git";
    name = mkOption {
      type = types.str;
      default = false;
      description = "Sets your username for git.";
    };
    email = mkOption {
      type = types.str;
      default = false;
      description = "Sets your email for git.";
    };
  };
  config = mkIf cfg.enable {
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
          inherit (cfg) name email;
        };
        signing = {
          format = "ssh";
        };
      };
    };
  };
}
