{ ... }:

{
  home.file = {
    # Symlink the entire .config directory
    ".config" = {
      source = "${./.config}";
      recursive = true;
      # force = true;
    };

    # Symlink the entire .local directory
    # ".local/scripts" = {
    #   source = ./.local/scripts;
    #   executable = true;
    # };
  };
}

