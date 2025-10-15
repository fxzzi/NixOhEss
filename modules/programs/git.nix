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
    gpgsigning.enable = mkEnableOption "GPG signing for git commits";
    gpgsigning.key = mkOption {
      type = types.str;
      default = "";
      description = "Sets your GPG key for signing git commits.";
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
          signingkey = mkIf cfg.gpgsigning.enable cfg.gpgsigning.key;
        };
        commit.gpgsign = cfg.gpgsigning.enable;
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
          "https://gitlab.com/" = {
            insteadOf = [
              "gl:"
              "gitlab:"
            ];
          };
        };
      };
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
