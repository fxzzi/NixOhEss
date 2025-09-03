{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) toString;
  cfg = config.cfg.programs.nh;
  keepCount = toString config.boot.loader.systemd-boot.configurationLimit;
in {
  options.cfg.programs.nh.enable = mkEnableOption "nh";
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${config.cfg.core.username}/.config/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        # it only needs to keep what can be shown in the bootloader
        extraArgs = "--keep ${keepCount}";
      };
    };
    environment.shellAliases = {
      nixupd = ''nix flake update --flake "$NH_FLAKE"; npins -d "$NH_FLAKE"/npins update'';

      # rb means rebuild
      rb = "nh os switch";
      rbu = "nixupd; rb";
      rbb = "nh os boot";
      rbbu = "nixupd; rbb";
    };
    hj.packages = [
      (pkgs.writeShellApplication
        {
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
              echo "Updating flake..."
              git -C "$NH_FLAKE" reset --hard origin/main
              echo "Rebuilding NixOS configuration..."
              nh os boot
              echo "Done! Updates will take effect on next boot."

              # Log the update
              LOG_DIR="$HOME/.local/share"
              LOG_FILE="$LOG_DIR/crb.txt"
              mkdir -p "$LOG_DIR"
              echo "$(date '+%Y-%m-%d %H:%M:%S') $OLD_COMMIT -> $NEW_COMMIT" >> "$LOG_FILE"
            else
              echo "No updates found. Exiting."
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
