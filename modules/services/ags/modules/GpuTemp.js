import GLib from "gi://GLib";
import Gio from "gi://Gio";

const readFile = (path) => {
  const [ok, bytes] = GLib.file_get_contents(path);
  return ok ? new TextDecoder().decode(bytes).trim() : null;
};

function listDir(path) {
  try {
    const iter = Gio.File.new_for_path(path).enumerate_children("standard::name", Gio.FileQueryInfoFlags.NONE, null);
    const names = [];
    let info;
    while ((info = iter.next_file(null)) !== null) names.push(info.get_name());
    return names;
  } catch (e) { return []; }
}

function findAmdGpuTempFile() {
  for (const dev of listDir("/sys/bus/pci/devices")) {
    const base = `/sys/bus/pci/devices/${dev}`;
    if (readFile(`${base}/vendor`) !== "0x1002") continue;
    for (const hwmon of listDir(`${base}/hwmon`)) {
      const f = `${base}/hwmon/${hwmon}/temp1_input`;
      if (GLib.file_test(f, GLib.FileTest.EXISTS)) {
        console.log(`Using AMD GPU temperature file: ${f}`);
        return f;
      }
    }
  }
  return null;
}

const gpuTempFilePath = (() => {
  const nvidia = "/tmp/nvidia-temp";
  if (GLib.file_test(nvidia, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
    console.log(`Using NVIDIA GPU temperature file: ${nvidia}`);
    return nvidia;
  }
  const amd = findAmdGpuTempFile();
  if (!amd) console.error("No valid GPU temperature path found.");
  return amd;
})();

const gpuTemp = Variable("", {
  poll: [5000, () => {
    if (!gpuTempFilePath) return "N/A";
    const raw = readFile(gpuTempFilePath);
    return raw ? `${(parseFloat(raw) / 1000).toFixed(0)}°C` : "N/A";
  }],
});

export function GpuTempWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({ icon: "expansion-card-symbolic", class_name: "icon", size: 16 }),
      Widget.Label({ class_name: "temperature-usage", label: gpuTemp.bind() }),
    ],
  });
}
