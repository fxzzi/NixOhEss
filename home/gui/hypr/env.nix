{ ... }:
{
  home.sessionVariables = {
    # run electron, gtk, qt apps in wayland native
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";

    # fix java bug on tiling wm's / compositors
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # nvidia shenanigans
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    __GL_SYNC_TO_VBLANK = "0";

    # enable these when nvidia gets their shit together
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";

  };
}
