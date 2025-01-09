{
  config,
  lib,
  ...
}: {
  options.audio.pipewire.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the PipeWire audio server";
  };
  config = lib.mkIf config.audio.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Optional but recommended
    security.rtkit.enable = true;
  };
  imports = [./rnnoise];
}
