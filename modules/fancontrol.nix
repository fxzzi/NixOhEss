{ config, pkgs, ... }:

{
  hardware = {
    fancontrol = {
       enable = false; # Enable fancontrol to control case fans depending on CPU and GPU temps
       config =
       ''
         INTERVAL=5
         DEVPATH=hwmon2=devices/platform/asus-ec-sensors hwmon5=devices/platform/nct6775.656
         DEVNAME=hwmon2=zenmonitor hwmon5=nct6798 
         FCTEMPS=hwmon5/pwm1=/tmp/nvidia-temp hwmon5/pwm2=hwmon2/temp1_input
         #FCTEMPS=hwmon5/pwm1=/hwmon2/temp1_input hwmon5/pwm2=/tmp/nvidia-temp
         FCFANS=hwmon5/pwm1=hwmon5/fan1_input hwmon5/pwm2=hwmon5/fan2_input 
         MINTEMP=hwmon5/pwm1=55 hwmon5/pwm2=40
         MAXTEMP=hwmon5/pwm1=100 hwmon5/pwm2=100
         MINSTART=hwmon5/pwm1=15 hwmon5/pwm2=15 
         MINSTOP=hwmon5/pwm1=50 hwmon5/pwm2=65
         MINPWM=hwmon5/pwm1=50 hwmon5/pwm2=65
       '';
    };
  };
}
