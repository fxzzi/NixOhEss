{
  pkgs,
  config,
  ...
}: {
  # this is NOT NixOS!!!!!!!! This is NIXOHESS!!!!!!
  system.nixos.distroName = "NixOhEss";
  environment.etc.issue = {
    # a disgusting mess of escape codes to make it look nice. extra line on purpose for spacing.
    source = pkgs.writeText "issue" ''
      \e[32mWelcome to the fold of ${config.system.nixos.distroName}, \e[36m${config.cfg.core.username}\e[1;32m. \e[2m(\l)\e[0m

    '';
  };
}
