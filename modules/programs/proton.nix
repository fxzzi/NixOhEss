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
    listToAttrs
    mapAttrs
    ;
  cfg = config.cfg.programs.proton;

  withSettings = p: p.overrideAttrs { userSettings = cfg.settings; };
in
{
  options.cfg.programs.proton = {
    enable = mkEnableOption "proton";
    nativeWayland = mkEnableOption "Wayland native proton";
    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        proton-ge-bin
        proton-cachyos-bin
        proton-wineland-bin
      ];
      description = "Proton builds to install into Steam's compatibilitytools.d.";
    };
    settings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          int
        ]);
      default = { };
      apply = mapAttrs (_: toString);
      description = ''
        Set environment variables for all proton builds
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "ntsync" ];

    cfg.programs.proton.settings = {
      PROTON_ENABLE_WAYLAND = mkIf cfg.nativeWayland 1;
      PROTON_USE_WOW64 = 1;
    };

    # heroic and lutris both pick up protons from here too
    hj.xdg.data.files = listToAttrs (
      map (p: {
        name = "Steam/compatibilitytools.d/${p.steamDisplayName}";
        value.source = (withSettings p).steamcompattool;
      }) cfg.packages
    );
  };
}
