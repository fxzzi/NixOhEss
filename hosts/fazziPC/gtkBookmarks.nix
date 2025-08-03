{
  lib,
  config,
  ...
}: let
  bookmarks = [
    "file:///games Games"
    "file:///home/${config.cfg.core.username}/.local/torrents Torrents"
  ];
in {
  config = {
    hj.xdg.config.files."gtk-3.0/bookmarks".text = lib.mkAfter (lib.concatMapStrings (l: l + "\n") bookmarks);
  };
}
