{
  pkgs,
  lib,
  user,
  inputs,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.default
    # avoid boilerplate in the configuration
    (lib.modules.mkAliasOptionModule ["hj"] ["hjem" "users" user])
  ];
  config = {
    hjem = {
      clobberByDefault = true;
      linker = inputs.smfh.packages.${pkgs.system}.default;
      users.${user} = {
        enable = true;
        inherit user;
        # These are available no matter the host.
        packages = with pkgs; [
          wget
          ffmpeg
          imagemagick
          # pwvucontrol
          lxqt.pavucontrol-qt
          mate.atril
          mate.eom
          libreoffice
          hunspell
          hunspellDicts.en_GB-ise
          npins
          yt-dlp
          xournalpp
          stremio
        ];
      };
    };

    users.users.${user} = {
      isNormalUser = true;
      # so you can login the first time.
      # PLEASE change this after logging in
      initialPassword = "1234";
      extraGroups = [
        "wheel" # sudo
      ];
      uid = 1000;
    };
  };
}
