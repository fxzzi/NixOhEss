const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

function findAmdGpuTempFile() {
  try {
    const pciPath = "/sys/bus/pci/devices";
    const pciDir = Gio.File.new_for_path(pciPath);
    const enumerator = pciDir.enumerate_children("standard::name", Gio.FileQueryInfoFlags.NONE, null);

    let fileInfo;
    while ((fileInfo = enumerator.next_file(null)) !== null) {
      const devicePath = `${pciPath}/${fileInfo.get_name()}`;
      const vendorPath = `${devicePath}/vendor`;

      const [success, vendorBytes] = GLib.file_get_contents(vendorPath);
      if (success && new TextDecoder().decode(vendorBytes).trim() === "0x1002") {
        const hwmonPath = `${devicePath}/hwmon`;
        if (GLib.file_test(hwmonPath, GLib.FileTest.IS_DIR)) {
          const hwmonDir = Gio.File.new_for_path(hwmonPath);
          const hwmonEnumerator = hwmonDir.enumerate_children("standard::name", Gio.FileQueryInfoFlags.NONE, null);
          let hwmonInfo;
          while ((hwmonInfo = hwmonEnumerator.next_file(null)) !== null) {
            const tempFile = `${hwmonPath}/${hwmonInfo.get_name()}/temp1_input`;
            if (GLib.file_test(tempFile, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
              console.log(`Using AMD GPU temperature file: ${tempFile}`);
              return tempFile;
            }
          }
        }
      }
    }
  } catch (error) {
    console.error("Error finding AMD GPU temperature file:", error);
  }
  return null;
}

function determineGpuTempFilePath() {
  const nvidiaTempPath = "/tmp/nvidia-temp";
  if (GLib.file_test(nvidiaTempPath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
    console.log(`Using NVIDIA GPU temperature file: ${nvidiaTempPath}`);
    return nvidiaTempPath;
  }

  const amdTempPath = findAmdGpuTempFile();
  if (amdTempPath) {
    return amdTempPath;
  }

  console.error("No valid GPU temperature path found.");
  return null;
}

const gpuTempFilePath = determineGpuTempFilePath();

const gpuTemp = Variable("", {
  poll: [
    5000,
    () => {
      if (!gpuTempFilePath) return "N/A";
      try {
        const [success, tempBytes] = GLib.file_get_contents(gpuTempFilePath);
        if (!success) return "N/A";
        const temp = parseFloat(new TextDecoder().decode(tempBytes)) / 1000;
        return `${temp.toFixed(0)}°C`;
      } catch (error) {
        console.error("Error reading GPU temperature from", gpuTempFilePath, ":", error);
        return "N/A";
      }
    },
  ],
});

export function GpuTempWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "expansion-card-symbolic",
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        class_name: "temperature-usage",
        label: gpuTemp.bind(),
      }),
    ],
  });
}
