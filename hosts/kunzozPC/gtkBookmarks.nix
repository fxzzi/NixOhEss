{lib, ...}: let
  bookmarks = [
    "file:///mnt/windows-kunzoz Windoes"
    "file:///mnt/windows-dad Job"
  ];
in {
  config = {
    hj.xdg.config.files."gtk-3.0/bookmarks".text = lib.mkAfter (lib.concatMapStrings (l: l + "\n") bookmarks);
  };
}
