{
  lib,
  config,
  ...
}: {
  config = {
    environment.sessionVariables = lib.mkMerge [
      {
        # run electron, gtk, qt apps in wayland native
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";

        # fix java bug on tiling wm's / compositors
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # HYPRLAND_TRACE = "1";
      }
      (lib.mkIf config.cfg.gpu.nvidia.enable {
        # nvidia shenanigans
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";

        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";

        # NOTE: https://download.nvidia.com/XFree86/Linux-x86_64/575.51.02/README/openglenvvariables.html
        __GL_YIELD = "USLEEP";

        # shader caches are getting larger - don't clean them up
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      })
    ];
  };
}
