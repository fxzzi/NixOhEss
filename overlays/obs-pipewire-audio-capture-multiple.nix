{ npins, ... }:

/* this nixpkgs overlay makes the obs-pipewire-audio-capture
   obs plugin use its `multiple-apps-per-source` branch, for
   selecting multiple audio sources for one obs source.

   See: https://github.com/dimtpap/obs-pipewire-audio-capture/tree/multiple-apps-per-source
*/

{
  nixpkgs.overlays = [
    (final: prev: {
      obs-studio-plugins = prev.obs-studio-plugins // {
        obs-pipewire-audio-capture =
          prev.obs-studio-plugins.obs-pipewire-audio-capture.overrideAttrs
          (old: {
            pname = "obs-studio-plugins.obs-pipewire-audio-capture-multiple";
            src = npins.obs-pipewire-audio-capture;
          });
      };
    })
  ];
}
