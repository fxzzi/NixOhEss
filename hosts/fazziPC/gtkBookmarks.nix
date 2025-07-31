{
  lib,
  user,
  ...
}: let
  bookmarks = [
    "file:///games Games"
    "file:///home/${user}/.local/torrents Torrents"
  ];
in {
  config = {
    hj = {
      files = {
        ".config/gtk-3.0/bookmarks".text = lib.mkAfter (lib.concatMapStrings (l: l + "\n") bookmarks);
      };
    };
  };
}
