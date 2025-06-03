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
        '';
      };
    };
    environment.sessionVariables = {
      SUDO_PROMPT = "[sudo: 󱅞 ] Password: "; # note the extra space
    };
  };
}
