{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) toString;
  cfg = config.cfg.programs.nh;
in
{
  options.cfg.programs.nh.enable = mkEnableOption "nh";
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "${config.hj.directory}/.config/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        # it only needs to keep what can be shown in the bootloader
        extraArgs = "--keep ${toString config.boot.loader.limine.maxGenerations}";
      };
    };
    environment.shellAliases = {
      # rb means rebuild
      rb = "nh os switch";
      rbu = "nixupd; rb";
      rbb = "nh os boot";
    };
    hj.packages = [
      (pkgs.writeShellApplication {
        name = "crb";
        runtimeInputs = with pkgs; [
          nh
          git
          coreutils
        ];
        text = ''
          # Save the current commit hash of origin/main before fetching
          OLD_COMMIT=$(git -C "$NH_FLAKE" rev-parse origin/main)
          # Fetch from origin
          git -C "$NH_FLAKE" fetch origin
          # Get the new commit hash of origin/main after fetching
          NEW_COMMIT=$(git -C "$NH_FLAKE" rev-parse origin/main)

          # Compare commits and continue only if they differ
          if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
            echo "updoots available :)"
            git -C "$NH_FLAKE" reset --hard origin/main
            nh os boot
            echo "updoot finished please reboot :)"
          else
            echo "you're up to date :)"
            exit 0
          fi
        '';
      })

      (pkgs.writeShellApplication {
        name = "evaltime";
        text = ''
          # use current host if one isn't given
          HOST="''${1:-$(hostname)}"
          time nix eval \
            "$NH_FLAKE"#nixosConfigurations."$HOST".config.system.build.toplevel \
            --substituters " " \
            --option eval-cache false \
            --raw --read-only
        '';
      })
    ];
  };
}
