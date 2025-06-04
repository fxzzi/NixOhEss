_: {
  config = {
    security = {
      sudo = {
        enable = true;
        execWheelOnly = true;
        # show asterisks when typing password
        extraConfig = ''
          Defaults pwfeedback
          Defaults env_keep += "EDITOR PATH DISPLAY"

          # custom sudo prompt
          Defaults passprompt = "[sudo 󱅞 ]: "
        '';
      };
    };
  };
}
