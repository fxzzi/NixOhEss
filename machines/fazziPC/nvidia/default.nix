{ config, pkgs, lib, inputs, ... }: {
  nixpkgs.config.allowUnfree =
    true; # Allow installing of Unfree software, mostly nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = true; # Set to false until wake-up from suspend is fixed
      modesetting.enable =
        true; # Enable modesetting in nvidia for nvidia-vaapi-driver
      powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
      package =
        config.boot.kernelPackages.nvidiaPackages.beta; # Use beta drivers
      nvidiaSettings =
        false; # Disable nvidia-settings applet, useless on Wayland
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ libva libva-utils nvidia-vaapi-driver ];
    };
  };
  systemd = {
    services.nvidia-gpu-temperature = {
      description = "NVidia GPU temperature monitoring";
      wantedBy = [ "multi-user.target" ];
      before = [ "fancontrol.service" ];
      script = "	while :; do\n		t=\"$(${
            lib.getExe' config.hardware.nvidia.package "nvidia-smi"
          } --query-gpu=temperature.gpu --format=csv,noheader,nounits)\"\n		echo \"$((t * 1000))\" > /tmp/nvidia-temp\n		sleep 5\n	done\n";
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
        ExecStart = "${
            lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv
          } 1830 205 1000 150";
      };
    };
  };
}
