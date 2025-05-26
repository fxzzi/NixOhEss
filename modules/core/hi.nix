{pkgs, lib, ...}: let
  updateHashesScript = pkgs.writeShellApplication {
    name = "update-balatro-hashes";

    runtimeInputs = [
      pkgs.curl
      pkgs.jq
      pkgs.gnused
      config.nix.package # use system's nix package (lix for example)
    ];

    text = ''
      MODS_FILE="$HOME/nixos/home/modules/gaming/balatro/mods.nix"

      if [ ! -f "$MODS_FILE" ]; then
        echo "Error: $MODS_FILE not found!"
        exit 1
      fi

      echo "Updating Balatro mod hashes..."

      # Function to get latest commit hash
      get_latest_commit() {
          local owner="$1"
          local repo="$2"
          local branch="''${3:-main}"
          curl -s "https://api.github.com/repos/$owner/$repo/commits/$branch" | jq -r '.sha'
      }

      # Function to get GitHub repo hash
      get_github_hash() {
          local owner="$1"
          local repo="$2"
          local rev="$3"
          nix-shell -p nix-prefetch-github --run "nix-prefetch-github $owner $repo --rev $rev" | jq -r '.hash'
      }

      # Function to get file hash
      get_file_hash() {
          local url="$1"
          nix-prefetch-url "$url"
      }

      # Function to update a repo mod
      update_repo_mod() {
          local mod_name="$1"
          local owner="$2"
          local repo="$3"

          echo "Updating $mod_name..."
          local new_rev=$(get_latest_commit "$owner" "$repo")
          local new_hash=$(get_github_hash "$owner" "$repo" "$new_rev")

          # Update rev
          sed -i "/$mod_name = {/,/};/{
            s/rev = \"[^\"]*\";/rev = \"$new_rev\";/
          }" "$MODS_FILE"

          # Update sha256
          sed -i "/$mod_name = {/,/};/{
            s/sha256 = \"[^\"]*\";/sha256 = \"$new_hash\";/
          }" "$MODS_FILE"

          echo "  $mod_name: $new_rev"
      }

      # Function to update a file mod
      update_file_mod() {
          local mod_name="$1"
          local url="$2"

          echo "Updating $mod_name..."
          local new_hash=$(get_file_hash "$url")

          # Update sha256
          sed -i "/$mod_name = {/,/};/{
            s/sha256 = \"[^\"]*\";/sha256 = \"$new_hash\";/
          }" "$MODS_FILE"

          echo "  $mod_name: $new_hash"
      }

      # Update all repository mods
      update_repo_mod "steamodded" "Steamodded" "smods"
      update_repo_mod "talisman" "SpectralPack" "Talisman"
      update_repo_mod "cryptid" "SpectralPack" "Cryptid"
      update_repo_mod "multiplayer" "Balatro-Multiplayer" "BalatroMultiplayer"
      update_repo_mod "cardsleeves" "larswijn" "CardSleeves"
      update_repo_mod "jokerdisplay" "nh6574" "JokerDisplay"
      update_repo_mod "pokermon" "InertSteak" "Pokermon"

      # Update file mods
      update_file_mod "morespeeds" "https://raw.githubusercontent.com/Steamodded/examples/refs/heads/master/Mods/MoreSpeeds.lua"
      update_file_mod "overlay" "https://raw.githubusercontent.com/cantlookback/BalatrOverlay/refs/heads/main/balatroverlay.lua"

      echo ""
      echo "✅ All mod hashes updated successfully!"
      echo "📁 Updated file: $MODS_FILE"
      echo "🔄 Run 'nh os switch --dry' to preview changes, then 'nh os switch' to apply"
    '';
  }
in
  {
    hj.packages = [
      updateHashesScript
    ];
  }
