{
  hostName,
  ...
}:
let
  quad9DNS = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
    "2620:fe::fe#dns.quad9.net"
    "2620:fe::9#dns.quad9.net"
  ];
  cloudflareDNS = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
    "2606:4700:4700::1111#one.one.one.one"
    "2606:4700:4700::1001#one.one.one.one"
  ];
  googleDNS = [
    "8.8.8.8#dns.google"
    "8.8.4.4#dns.google"
    "2001:4860:4860::8888#dns.google"
    "2001:4860:4860::8844#dns.google"
  ];
in
{
  config = {
    boot = {
      # bufferbloat mititgation
      kernel.sysctl = {
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };
    };
    networking = {
      inherit hostName;
      nameservers = cloudflareDNS;
      dhcpcd.wait = "background";
    };
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = "opportunistic";
        DNSSEC = "allow-downgrade";
        # avahi already does mDNS, two stacks on the same port make discovery unreliable
        MulticastDNS = false;
        FallbackDNS = quad9DNS ++ googleDNS;
      };
    };
  };
}
