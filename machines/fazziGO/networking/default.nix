{ ... }:
{
	networking = {
		networkmanager = {
			enable = true;
			wifi.powersave = true;
			dns = "systemd-resolved";
		};
	};
}
