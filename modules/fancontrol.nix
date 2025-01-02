{ config, pkgs, ... }:

{
  hardware = {
    fancontrol = {
      enable = true; # Enable fancontrol to control case fans depending on CPU and GPU temps
      config =
        ''
          INTERVAL=4
          DEVPATH=hwmon2=devices/pci0000:00/0000:00:18.3 hwmon5=devices/platform/nct6775.656
          DEVNAME=hwmon2=zenpower hwmon5=nct6798
          FCTEMPS=hwmon5/pwm2=hwmon2/temp1_input hwmon5/pwm1=/tmp/nvidia-temp
          FCFANS= hwmon5/pwm2=hwmon5/fan2_input hwmon5/pwm1=hwmon5/fan1_input
          MINTEMP=hwmon5/pwm2=40 hwmon5/pwm1=40
          MAXTEMP=hwmon5/pwm2=100 hwmon5/pwm1=100
          MINSTART=hwmon5/pwm2=42 hwmon5/pwm1=42
          MINSTOP=hwmon5/pwm2=42 hwmon5/pwm1=42
          MINPWM=hwmon5/pwm2=42 hwmon5/pwm1=42
          MAXPWM=hwmon5/pwm2=255 hwmon5/pwm1=255
          			'';
    };
  };
}
