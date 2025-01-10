{npins, ...}:
/*
this nixpkgs overlay bumps the obs-pipewire-audio-capture
obs plugin to latest git, for the new option of
selecting multiple audio sources for one obs source.

See: https://github.com/dimtpap/obs-pipewire-audio-capture/commit/a8647b1
*/
{
  nixpkgs.overlays = [
    (_final: prev: {
      obs-studio-plugins =
        prev.obs-studio-plugins
        // {
          obs-pipewire-audio-capture =
            prev.obs-studio-plugins.obs-pipewire-audio-capture.overrideAttrs
            (_old: {
              pname = "obs-studio-plugins.obs-pipewire-audio-capture-git";
              src = npins.obs-pipewire-audio-capture;
              cmakeFlags = [
                "-DCMAKE_INSTALL_LIBDIR=./lib"
                "-DCMAKE_INSTALL_DATADIR=./usr"
              ];
            });
        };
    })
  ];
}
