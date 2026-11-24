{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
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
    # thanks raf!
    # <https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/nix/module.nix#L236>
    systemd.services.nh-clean.unitConfig.ConditionACPower = true;
    environment.shellAliases = {
      # rb means rebuild
      rb = "nh os switch";
      rbb = "nh os boot";
    };
    hj.packages = [
      (pkgs.writeShellApplication {
        name = "crb";
        runtimeInputs = with pkgs; [
          config.nix.package
          config.programs.nh.package
          git
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
            # build any patched inputs from tack
            nix-build "$NH_FLAKE/.tack" -A _patched -o "$NH_FLAKE/.tack/patched"
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
