{hostName, ...}: {
  config = {
    networking = {
      inherit hostName;
      dhcpcd.wait = "background"; # fork to background immediately.
      # Use Cloudflare DNS
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "2606:4700:4700::1111#one.one.one.one"
        "2606:4700:4700::1001#one.one.one.one"
      ];
    };
    services.resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };
  };
}
