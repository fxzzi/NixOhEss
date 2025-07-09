{
  config,
  lib,
  ...
}: {
  options.cfg.audio.pipewire.enable = lib.mkEnableOption "pipewire";
  config = lib.mkIf config.cfg.audio.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire-pulse."92-rtkit" = {
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

    security.rtkit.enable = true;
  };
  imports = [./rnnoise.nix];
}
