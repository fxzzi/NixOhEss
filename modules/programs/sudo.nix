{...}: {
  config = {
    security = {
      sudo-rs = {
        enable = true;
        execWheelOnly = true;
        # show asterisks when typing password
        configFile = ''
          Defaults pwfeedback
          Defaults env_keep += "EDITOR PATH DISPLAY"
        '';
      };
    };
    environment.sessionVariables = {
      SUDO_PROMPT = "󱅞 "; # note the extra space
    };
  };
}
