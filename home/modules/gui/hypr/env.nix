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

      # nvidia got their shit together in 570,
      # so we can now enable!! rejoice!!
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    })
  ];
}
