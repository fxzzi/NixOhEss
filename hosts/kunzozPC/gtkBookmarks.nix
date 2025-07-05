{lib, ...}: let
  bookmarks = [
    "file:///mnt/windows-kunzoz Windoes"
    "file:///mnt/windows-dad Job"
  ];
in {
  config = {
    hj = {
      files = {
        ".config/gtk-3.0/bookmarks".text = lib.mkAfter (lib.concatMapStrings (l: l + "\n") bookmarks);
      };
    };
    users.users.ermwhat = {
      isNormalUser = true;
      initialPassword = "69420";
      extraGroups = [
        "wheel"
      ];
      uid = 1069;
    };
  };
}
