const GLib = imports.gi.GLib;

// Variable to store the selected temperature file path.
let tempFilePath;

function determineTempFilePath() {
  const thinkpadPath = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon6/temp1_input";
  const fallbackPath = "/sys/class/hwmon/hwmon2/temp1_input";

  // Check if ThinkPad-specific path exists and is readable.
  try {
    if (GLib.file_test(thinkpadPath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
      return thinkpadPath;
    }
  } catch (error) {
    console.warn("ThinkPad temperature path check failed:", error);
  }

  // Fallback to general path if ThinkPad path is not available.
  return fallbackPath;
}

tempFilePath = determineTempFilePath();

const cpuTemp = Variable("", {
  poll: [
    5000,
    () => {
      try {
        const [success, tempBytes] = GLib.file_get_contents(tempFilePath);
        const temp = success
          ? parseFloat(new TextDecoder("utf-8").decode(tempBytes)) / 1000
          : null; // Convert mC to C

        return temp ? `${temp.toFixed(0)}°C` : "N/A";
      } catch (error) {
        console.error("Error reading CPU temperature from", tempFilePath, ":", error);
        return "N/A";
      }
    },
  ],
});

export function CpuTempWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "thermometer-outline-symbolic",
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        class_name: "temperature-usage",
        label: cpuTemp.bind(),
      }),
    ],
  });
}
