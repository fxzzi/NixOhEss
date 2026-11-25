{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    genAttrs'
    nameValuePair
    mapAttrs
    ;
  cfg = config.cfg.programs.proton;

  # setting userSettings in mkProtonBinDerivation is a simple way
  # to set environment variables for the proton build only.
  withSettings = p: p.overrideAttrs { userSettings = cfg.environmentVariables; };
in
{
  options.cfg.programs.proton = {
    enable = mkEnableOption "proton";
    packages = mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.proton-ge-bin
      ];
      description = "Proton builds to install into Steam's compatibilitytools.d.";
    };
    environmentVariables = mkOption {
      type = with types; attrsOf (either str int);
      default = { };
      apply = mapAttrs (_: toString);
      description = "Set environment variables for all proton builds.";
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "ntsync" ];

    cfg.programs.proton.environmentVariables = {
      # WOW64 by default should be fine
      PROTON_USE_WOW64 = 1;
      # Native pipewire instead of PA, available in GE and cachyOS
      PROTON_USE_PIPEWIRE = 1;
      # use native HDR colorspace so that steam overlay and mangohud
      # aren't oversaturated and blown out
      WINE_WAYLAND_HDR_NATIVE = 1;
    };

    # heroic and lutris both pick up protons from here too
    hj.xdg.data.files = genAttrs' cfg.packages (
      p:
      nameValuePair "Steam/compatibilitytools.d/${p.steamDisplayName}" {
        source = (withSettings p).steamcompattool;
      }
    );
  };
}
