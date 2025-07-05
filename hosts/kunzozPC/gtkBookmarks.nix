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
    users.users.hjemming = {
      isNormalUser = true;
      password = "69420";
      extraGroups = [
        "wheel"
      ];
      uid = 1069;
    };
    services.openssh = {
      enable = true;
      ports = [
        25565
      ];
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 25565;
        }
      ];
    };
  };
}
