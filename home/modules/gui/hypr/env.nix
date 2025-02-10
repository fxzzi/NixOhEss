{
  osConfig,
  lib,
  ...
}: {
  home.sessionVariables = lib.mkMerge [
    {
      # run electron, gtk, qt apps in wayland native
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";

      # fix java bug on tiling wm's / compositors
      _JAVA_AWT_WM_NONREPARENTING = "1";
    }
    (lib.mkIf osConfig.gpu.nvidia.enable {
      # nvidia shenanigans
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # disable vsync
      __GL_SYNC_TO_VBLANK = "0";
      # enable gsync / vrr support
      __GL_VRR_ALLOWED = "1";
    })
  ];
}
