_: {
  config = {
    security = {
      sudo = {
        enable = true;
        execWheelOnly = true;
        extraConfig = ''
          # disable lecture on first use
          Defaults lecture=never
          # show asterisks when entering password
          Defaults pwfeedback
          # keep some environment variables
          Defaults env_keep += "EDITOR PATH DISPLAY"
          # custom sudo prompt
          Defaults passprompt = "[sudo 󱅞 ]: "
        '';
        extraRules = [
          {
            groups = ["wheel"];
            commands = [
              {
                command = "/run/current-system/sw/bin/systemctl kexec";
                options = ["NOPASSWD"];
              }
            ];
          }
        ];
      };
    };
  };
}
