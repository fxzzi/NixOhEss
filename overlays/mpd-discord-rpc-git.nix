{npins, ...}:
/*
This nixpkgs overlay bumps `mpd-discord-rpc` to the latest master
for some features that haven't made it into a release yet.

See: https://github.com/JakeStanger/mpd-discord-rpc/commit/fdfa3dd
*/
{
  nixpkgs.overlays = [
    (_final: prev: {
      mpd-discord-rpc = prev.mpd-discord-rpc.overrideAttrs (oldAttrs: rec {
        pname = "mpd-discord-rpc-git";
        src = npins.mpd-discord-rpc;
        cargoDeps = oldAttrs.cargoDeps.overrideAttrs (
          prev.lib.const {
            inherit src;
            outputHash = "sha256-mhB4EybLvfme8GyB3AbeXkEIEVOdsUIllYBiTWEPdMk=";
          }
        );
      });
    })
  ];
}
