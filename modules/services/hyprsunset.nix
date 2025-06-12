{
  lib,
  xLib,
  config,
  inputs,
  pkgs,
  user,
  ...
}: let
  pkg =
    if config.cfg.gui.hypr.useGit
    then inputs.hyprsunset.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.cfg.gui.hypr.hyprsunset.enable = lib.mkEnableOption "hyprsunset";
  config = lib.mkIf config.cfg.gui.hypr.hyprsunset.enable {
    hj = {
      files = {
        ".local/share/walls".source = "${inputs.walls}/images"; # wallpapers
      };

      packages = [
        pkg.hyprsunset
      ];
    };
    systemd.user.services.hyprsunset = {
      enable = true;
      description = "An application to enable a blue-light filter on Hyprland.";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        # --identity starts hyprsunset without changing temperature
        ExecStart = "${lib.getExe pkg.hyprsunset} --identity";
      };
    };
  };
}
