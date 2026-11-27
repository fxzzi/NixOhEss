{
  config = {
    security = {
      sudo.enable = false;
      run0 = {
        enable = true;
        sudo-shim.enable = true;
        # cache auth like sudo's timestamp instead of asking every time
        persistentAuth = {
          enable = true;
          enableRemote = true;
        };
      };
    };
    # don't do that ugly red tint during run0
    environment.sessionVariables.SYSTEMD_TINT_BACKGROUND = 0;
  };
}
