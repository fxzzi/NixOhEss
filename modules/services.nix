{ config, pkgs, lib, inputs, ... }: 

{
  # List services that you want to enable:
  services = {
    printing.enable = true;
    tumbler.enable = true; # Thunar thumbnailer
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
    gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
  };

  security.polkit.enable = true; # Enable polkit for root access in GUI apps
  security.rtkit.enable = true; # Enable RTKit service for Pipewire priority
  security.pam.services.faaris.enableGnomeKeyring = true; # Enable gnome keyring for user

	systemd = {
		services.nvidia-gpu-temperature = {
			description = "NVidia GPU temperature monitoring";
			wantedBy = [ "multi-user.target" ];
			before = [ "fancontrol.service" ];
			script = ''
				while :; do
					t="$(${lib.getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
					echo "$((t * 1000))" > /tmp/nvidia-temp
					sleep 5
				done
			'';
			serviceConfig = {
				Type = "simple";
				Restart = "always";
				RestartSec = 5;
			};
		};
		services.nvidia-undervolt = {
			description = "NVidia Undervolting script";
			wantedBy = [ "multi-user.target" ];
			serviceConfig = {
				ExecStart = "${lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv} 1830 205 1000 150";
			};
		};
	};
}
