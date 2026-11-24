{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    replaceStrings
    ;
  cfg = config.cfg.programs.git;
in
{
  options.cfg.programs.git = {
    enable = mkEnableOption "git";
    name = mkOption {
      type = types.str;
      default = config.cfg.core.username;
      description = "Sets your username for git.";
    };
    email = mkOption {
      type = types.str;
      default = "${config.cfg.core.username}@example.com";
      apply = replaceStrings [ "<at>" "<dot>" ] [ "@" "." ];
      description = "Sets your email for git. `<at>` and `<dot>` are decoded, to keep it away from scrapers.";
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
        init = {
          defaultBranch = "main";
        };
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
    };
  };
}
