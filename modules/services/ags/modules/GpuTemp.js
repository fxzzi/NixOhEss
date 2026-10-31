import GLib from "gi://GLib";
import Gio from "gi://Gio";

const readFile = (path) => {
  const [ok, bytes] = GLib.file_get_contents(path);
  return ok ? new TextDecoder().decode(bytes).trim() : null;
};

function listDir(path) {
  try {
    const iter = Gio.File.new_for_path(path).enumerate_children(
      "standard::name",
      Gio.FileQueryInfoFlags.NONE,
      null,
    );
    const names = [];
    let info;
    while ((info = iter.next_file(null)) !== null) names.push(info.get_name());
    return names;
  } catch (e) {
    return [];
  }
}

function findGpuTempFile() {
  const gpuVendors = ["0x10de", "0x1002"];

  for (const dev of listDir("/sys/bus/pci/devices")) {
    const base = `/sys/bus/pci/devices/${dev}`;
    const vendor = readFile(`${base}/vendor`);

    if (!gpuVendors.includes(vendor)) continue;

    for (const hwmon of listDir(`${base}/hwmon`)) {
      const f = `${base}/hwmon/${hwmon}/temp1_input`;

      if (GLib.file_test(f, GLib.FileTest.EXISTS)) {
        console.log(`Using GPU temperature file: ${f}`);
        return f;
      }
    }
  }

  console.error("No valid GPU temperature path found.");
  return null;
}

const gpuTempFilePath = findGpuTempFile();

const gpuTemp = Variable("", {
  poll: [
    5000,
    () => {
      if (!gpuTempFilePath) return "N/A";

      const raw = readFile(gpuTempFilePath);
      return raw ? `${(parseFloat(raw) / 1000).toFixed(0)}°C` : "N/A";
    },
  ],
});

export function GpuTempWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "expansion-card-symbolic",
        class_name: "icon",
        size: 16,
      }),
      Widget.Label({
        class_name: "temperature-usage",
        label: gpuTemp.bind(),
      }),
    ],
  });
}
