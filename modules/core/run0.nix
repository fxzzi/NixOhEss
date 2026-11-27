{
  config = {
    security = {
      sudo.enable = false;
      # persist auth for 10 mins instead of default 5
      polkit.settings.Polkitd.ExpirationSeconds = 600;
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
