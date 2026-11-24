{ config, lib, ... }:
let
  inherit (lib) any attrValues mkIf;
  hasBtrfs = any (fs: fs.fsType == "btrfs") (attrValues config.fileSystems);
in
{
  config = mkIf hasBtrfs {
    services.btrfs.autoScrub.enable = true;
    # don't run whilst on battery
    systemd.services."btrfs-scrub@".unitConfig.ConditionACPower = true;
  };
}
