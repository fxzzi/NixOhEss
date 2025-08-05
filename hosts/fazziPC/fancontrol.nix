{pkgs, ...}: let
  nct_hwmon = "/sys/devices/platform/nct6775.656/hwmon/hwmon[[:print:]]*";
  k10temp_hwmon = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon[[:print:]]*";
  pwm1 = "${nct_hwmon}/pwm1";
  pwm2 = "${nct_hwmon}/pwm2";
  fan1 = "${nct_hwmon}/fan1_input";
  fan2 = "${nct_hwmon}/fan2_input";
  cpu_temp = "${k10temp_hwmon}/temp1_input";
  gpu_temp = "/tmp/nvidia-temp";
  minTemp = 35;
  maxTemp = 95;
  minPwm = 42;
  maxPwm = 255;
in {
  config = {
    environment.systemPackages = with pkgs; [lm_sensors];
    hardware.fancontrol = {
      enable = true;
      config = ''
        INTERVAL=4
        FCTEMPS=${pwm2}=${cpu_temp} ${pwm1}=${gpu_temp}
        FCFANS=${pwm2}=${fan2} ${pwm1}=${fan1}
        MINTEMP=${pwm2}=${toString minTemp} ${pwm1}=${toString minTemp}
        MAXTEMP=${pwm2}=${toString maxTemp} ${pwm1}=${toString maxTemp}
        MINSTART=${pwm2}=${toString minPwm} ${pwm1}=${toString minPwm}
        MINSTOP=${pwm2}=${toString minPwm} ${pwm1}=${toString minPwm}
        MINPWM=${pwm2}=${toString minPwm} ${pwm1}=${toString minPwm}
        MAXPWM=${pwm2}=${toString maxPwm} ${pwm1}=${toString maxPwm}
      '';
    };
  };
}
