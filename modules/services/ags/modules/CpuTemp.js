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

const sensorLabelPriority = [
  { regex: /^k10temp|^zenpower/, labels: ["Tdie", "Tctl"] },
  { regex: /^coretemp/, labels: ["Package id 0"] },
  { regex: /^atk0110/, labels: ["CPU Temperature"] },
  { regex: /^it8603/, labels: ["temp1"] },
  { regex: /^nct/, labels: ["TSI0_TEMP"] },
  { regex: /^asusec/, labels: ["CPU"] },
  { regex: /^l_pcs/, labels: ["Node 0 Max"] },
  { regex: /^cpuss0_/, labels: ["temp1"] },
];

function determineTempFilePath() {
  try {
    const candidates = listDir("/sys/class/hwmon")
      .map(h => {
        const path = `/sys/class/hwmon/${h}`;
        const i = sensorLabelPriority.findIndex(({ regex }) => regex.test(readFile(`${path}/name`)));
        return i !== -1 ? { path, priority: i, labels: sensorLabelPriority[i].labels } : null;
      })
      .filter(Boolean)
      .sort((a, b) => a.priority - b.priority);

    for (const { path, labels } of candidates) {
      const labelFiles = listDir(path).filter(f => f.startsWith("temp") && f.endsWith("_label"));
      for (const label of labels) {
        for (const file of labelFiles) {
          const filePath = `${path}/${file}`;
          if (readFile(filePath) === label) {
            const inputPath = filePath.replace("_label", "_input");
            if (GLib.file_test(inputPath, GLib.FileTest.EXISTS)) {
              console.log(`Using CPU temperature file: ${inputPath}`);
              return inputPath;
            }
          }
        }
      }
    }
  } catch (e) {
    console.error("Error determining CPU temp file:", e);
  }
  console.error("No valid CPU temperature path found.");
  return null;
}

const tempFilePath = determineTempFilePath();

const cpuTemp = Variable("", {
  poll: [5000, () => {
    if (!tempFilePath) return "N/A";
    const raw = readFile(tempFilePath);
    return raw ? `${(parseFloat(raw) / 1000).toFixed(0)}°C` : "N/A";
  }],
});

export function CpuTempWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({ icon: "thermometer-outline-symbolic", class_name: "icon", size: 16 }),
      Widget.Label({ class_name: "temperature-usage", label: cpuTemp.bind() }),
    ],
  });
}
