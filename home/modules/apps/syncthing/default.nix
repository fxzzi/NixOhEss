{user, ...}: {
  config = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
      settings = {
        devices = {
          "Pissel 7" = {
						id = "E7S5TI3-Z6VYMFB-EL7NZCS-JXQQFMO-7ZQ7U4U-YS6XZLJ-EP7CDON-M4AC7QK";
					};
        };
        folders = {
          "/home/${user}/Music" = {
            id = "music";
            devices = ["fazziGO" "Pissel 7"];
          };
        };
      };
    };
  };
}
