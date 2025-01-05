{ ... }:
{
  networking = {
    hostName = "faarnixOS";
		useDHCP = false;
    dhcpcd.enable = false; # Disable dhcpcd as we use a manual config below
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ]; # Use cloudflare DNS
    defaultGateway = "192.168.0.1";
    interfaces.enp6s0 = {
			useDHCP = false;
			ipv4.addresses = [{
				address = "192.168.0.46"; # Set a fixed local IP
				prefixLength = 24;
			}];
		};
  };
  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };

  services.mediamtx = {
    enable = true;
    settings = {
			# Enable publishing and reading streams with the WebRTC protocol.
			webrtc = true;
			webrtcAddress = ":8889";
			webrtcEncryption = false;
			webrtcServerKey = "server.key";
			webrtcServerCert = "server.crt";
			webrtcAllowOrigin = "*";
			webrtcTrustedProxies = [];
			webrtcLocalUDPAddress = ":8189";
			webrtcLocalTCPAddress = "";
			# WebRTC clients need to know the IP of the server.
			# Gather IPs from interfaces and send them to clients.
			webrtcIPsFromInterfaces = true;
			# List of interfaces whose IPs will be sent to clients.
			# An empty value means to use all available interfaces.
			webrtcIPsFromInterfacesList = [];
			# List of additional hosts or IPs to send to clients.
			webrtcAdditionalHosts = [];
			# ICE servers. Needed only when local listeners can't be reached by clients.
			# STUN servers allows to obtain and share the public IP of the server.
			# TURN/TURNS servers forces all traffic through them.
			webrtcICEServers2 = [];
				# - url = stun:stun.l.google.com:19302
				# if user is "AUTH_SECRET", then authentication is secret based.
				# the secret must be inserted into the password field.
				# username = ''
				# password = ''
				# clientOnly = false
			# Time to wait for the WebRTC handshake to complete.
			webrtcHandshakeTimeout = "10s";
			# Maximum time to gather video tracks.
			webrtcTrackGatherTimeout = "2s";
			# webrtc = true;
			# webrtcAddress = ":4200";
			# webrtcLocalUDPAddress = ":4200";
			# webrtcAdditionalHosts = [
			# 	"1.1.1.1"
			# 	"1.0.0.1"
			# 	"192.168.0.46"
			# ];
		};
  };
}
