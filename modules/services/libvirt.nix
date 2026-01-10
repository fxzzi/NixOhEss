{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.libvirt;
in {
  options.cfg.services.libvirt.enable = mkEnableOption "libvirtd / virt-manager";
  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;
    users.users.${config.cfg.core.username}.extraGroups = ["libvirtd"];
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
