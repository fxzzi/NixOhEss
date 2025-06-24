{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [lm_sensors];
    hardware = {
      fancontrol = {
        enable = true; # Enable fancontrol to control case fans depending on CPU and GPU temps
        config = ''
          INTERVAL=4
          FCTEMPS=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon[[:print:]]*/temp1_input /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=/tmp/nvidia-temp
          FCFANS=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/fan2_input /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/fan1_input
          MINTEMP=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=35 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=35
          MAXTEMP=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=90 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=90
          MINSTART=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=56 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=56
          MINSTOP=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=56 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=56
          MINPWM=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=56 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=56
          MAXPWM=/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm2=255 /sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*/pwm1=255
        '';
      };
    };
  };
}
