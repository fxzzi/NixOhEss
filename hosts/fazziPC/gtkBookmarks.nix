{
  lib,
  config,
  ...
}: let
  bookmarks = [
    "file:///games Games"
    "file://${config.hj.directory}/.local/torrents Torrents"
  ];
in {
  config = {
    hj.xdg.config.files."gtk-3.0/bookmarks".text = lib.mkAfter (lib.concatMapStrings (l: l + "\n") bookmarks);
  };
}
