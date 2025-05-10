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
    };

    # Optional but recommended
    security.rtkit.enable = true;
  };
  imports = [./rnnoise.nix];
}
