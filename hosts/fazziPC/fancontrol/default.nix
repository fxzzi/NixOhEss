{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lm_sensors ];
  hardware = {
    fancontrol = {
      enable = true; # Enable fancontrol to control case fans depending on CPU and GPU temps
      config = ''
        INTERVAL=4
        DEVPATH=hwmon3=devices/pci0000:00/0000:00:18.3 hwmon2=devices/platform/nct6775.656
        DEVNAME=hwmon3=zenpower hwmon2=nct6798
        FCTEMPS=hwmon2/pwm2=hwmon3/temp1_input hwmon2/pwm1=/tmp/nvidia-temp
        FCFANS= hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm1=hwmon2/fan1_input
        MINTEMP=hwmon2/pwm2=40 hwmon2/pwm1=40
        MAXTEMP=hwmon2/pwm2=100 hwmon2/pwm1=100
        MINSTART=hwmon2/pwm2=42 hwmon2/pwm1=42
        MINSTOP=hwmon2/pwm2=42 hwmon2/pwm1=42
        MINPWM=hwmon2/pwm2=42 hwmon2/pwm1=42
        MAXPWM=hwmon2/pwm2=255 hwmon2/pwm1=255
        			'';
    };
  };
}
