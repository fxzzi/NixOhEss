{lib, ...}: let
  bookmarks = [
    "file:///games Games"
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
