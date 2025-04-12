# Save the current commit hash of origin/main before fetching
OLD_COMMIT=$(git -C "$FLAKE" rev-parse origin/main)

# Fetch from origin
git -C "$FLAKE" fetch origin

# Get the new commit hash of origin/main after fetching
NEW_COMMIT=$(git -C "$FLAKE" rev-parse origin/main)

# Compare commits and continue only if they differ
if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
  echo "New updates found. Proceeding with reset and switch."
  git -C "$FLAKE" reset --hard origin/main
  nh os switch
else
  echo "No updates found. Exiting."
  exit 0
fi
