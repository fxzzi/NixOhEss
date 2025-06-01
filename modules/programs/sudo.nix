_: {
  config = {
    security = {
      sudo-rs = {
        enable = true;
        execWheelOnly = true;
        # show asterisks when typing password
        extraConfig = ''
          Defaults pwfeedback
        '';
      };
    };
    environment.sessionVariables = {
      SUDO_PROMPT = "󱅞 "; # note the extra space
    };
  };
}
