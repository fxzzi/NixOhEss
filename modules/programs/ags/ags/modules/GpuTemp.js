const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

function findAmdGpuTempFile() {
  const pciPath = "/sys/bus/pci/devices";

  try {
    const pciDir = Gio.File.new_for_path(pciPath);
    const enumerator = pciDir.enumerate_children("standard::name", Gio.FileQueryInfoFlags.NONE, null);

    let fileInfo;
    while ((fileInfo = enumerator.next_file(null)) !== null) {
      const devName = fileInfo.get_name();
      const deviceDir = `${pciPath}/${devName}`;

      // Check for AMD vendor ID
      const vendorPath = `${deviceDir}/vendor`;
      const [vendorSuccess, vendorBytes] = GLib.file_get_contents(vendorPath);
      if (!vendorSuccess) continue;

      const vendorId = new TextDecoder("utf-8").decode(vendorBytes).trim();
      if (vendorId !== "0x1002") continue; // AMD's PCI vendor ID

      const hwmonDirPath = `${deviceDir}/hwmon`;
      if (!GLib.file_test(hwmonDirPath, GLib.FileTest.IS_DIR)) continue;

      const hwmonDir = Gio.File.new_for_path(hwmonDirPath);
      const hwmonEnumerator = hwmonDir.enumerate_children("standard::name", Gio.FileQueryInfoFlags.NONE, null);

      let hwmonInfo;
      while ((hwmonInfo = hwmonEnumerator.next_file(null)) !== null) {
        const hwmonSubdir = hwmonInfo.get_name();
        const tempFile = `${hwmonDirPath}/${hwmonSubdir}/temp1_input`;

        if (GLib.file_test(tempFile, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
          console.log(`Using AMD GPU temperature file: ${tempFile}`);
          return tempFile;
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
  if (amdTempPath) return amdTempPath;

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
        const temp = success
          ? parseFloat(new TextDecoder("utf-8").decode(tempBytes)) / 1000
          : null;
        return temp ? `${temp.toFixed(0)}°C` : "N/A";
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
