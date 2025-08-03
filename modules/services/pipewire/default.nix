{
  config,
  lib,
  ...
}: {
  options.cfg.services.pipewire.enable = lib.mkEnableOption "pipewire";
  config = lib.mkIf config.cfg.services.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # NOTE: If we're using sched-ext, we shouldn't use rt in any way.
      # see: https://github.com/sched-ext/scx/issues/2496
      extraConfig.pipewire-pulse."91-rtkit" = lib.mkIf (!config.cfg.services.scx.enable) {
        context.modules = [
          {
            name = "libpipewire-module-rtkit";
            args = {
              # make audio extremely high priority to avoid crackling
              "nice.level" = -20;
              "rt.prio" = 99;
            };
          }
        ];
      };
    };

    # only enable if scx is disabled
    security.rtkit.enable = !config.cfg.services.scx.enable;
  };
  imports = [./rnnoise.nix];
}
