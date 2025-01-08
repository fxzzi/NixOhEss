{
  pkgs,
  hostName,
  lib,
  ...
}:
let
  keyLayout = if (hostName == "fazziGO") then "uk" else "us";
in
{
  boot = {
    loader = {
      timeout = 3; # Timeout before launching default entry
      systemd-boot = {
        enable = true; # Enable systemd-boot
        editor = false; # Disable editor for security
        consoleMode = "max"; # Set console mode to max resolution
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "nowatchdog"
      "mitigations=off"
    ]; # disable watchdog and mitigations (not needed on personal systems)
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # Set kernel to base linux
    tmp.useTmpfs = true; # /tmp is not on tmpfs by default (why??)
    tmp.tmpfsSize = "50%";
  };
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "${keyLayout}";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Set a percentage of RAM to zstd compressed swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
