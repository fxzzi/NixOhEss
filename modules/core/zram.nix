{ config, ... }: {
  zramSwap = {
    enable = true;
    # At the time of writing both desktops on NixOhEss have > 32GB of RAM,
    # so they can use the fast lz4.
    # laptop only has 16GB of RAM, so use zstd at level -1. This has better
    # compression ratio than lz4.
    memoryPercent = 150;
    algorithm = if config.cfg.core.isLaptop then "zstd(level=-1)" else "lz4";
  };
  boot = {
    kernelParams = [ "zswap.enabled=0" ];
    # - `vm.swappiness = 150` increase swapping aka compression to be
    #   able to cache more file page data
    # - `vm.watermark_boost_factor = 0` watermark boosting can cause unpredictable stalls as seen here:
    #   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1861359
    kernel.sysctl = {
      "vm.swappiness" = 150;
      "vm.watermark_boost_factor" = 0;
    };
  };
}
