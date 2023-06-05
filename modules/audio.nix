{ config, pkgs, ... }: 
{
  services.pipewire = {
    enable = true; # Enable pipewire for audio
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
}
