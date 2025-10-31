const GLib = imports.gi.GLib;
const Gio = imports.gi.Gio;

// Priority mapping for sensors and their corresponding temperature labels
const sensorLabelPriority = [
  { regex: /^k10temp/, labels: ["Tdie", "Tctl"] },
  { regex: /^zenpower/, labels: ["Tdie", "Tctl"] },
  { regex: /^coretemp/, labels: ["Package id 0"] },
  { regex: /^atk0110/, labels: ["CPU Temperature"] },
  { regex: /^it8603/, labels: ["temp1"] },
  { regex: /^nct/, labels: ["TSI0_TEMP"] },
  { regex: /^asusec/, labels: ["CPU"] },
  { regex: /^l_pcs/, labels: ["Node 0 Max"] },
  { regex: /^cpuss0_/, labels: ["temp1"] },
];

function findInputForLabel(directory, label) {
  const dir = Gio.File.new_for_path(directory);
  const enumerator = dir.enumerate_children('standard::name', Gio.FileQueryInfoFlags.NONE, null);

  let fileInfo;
  while ((fileInfo = enumerator.next_file(null)) !== null) {
    const fileName = fileInfo.get_name();
    if (fileName.startsWith('temp') && fileName.endsWith('_label')) {
      const labelFilePath = `${directory}/${fileName}`;
      const [success, contents] = GLib.file_get_contents(labelFilePath);
      if (success && new TextDecoder().decode(contents).trim() === label) {
        const inputFilePath = labelFilePath.replace('_label', '_input');
        if (GLib.file_test(inputFilePath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
          return inputFilePath;
        }
      }
    }
  }
  return null;
}

function determineTempFilePath() {
  try {
    const hwmonPath = '/sys/class/hwmon';
    const hwmonDir = Gio.File.new_for_path(hwmonPath);
    const hwmonEnumerator = hwmonDir.enumerate_children('standard::name', Gio.FileQueryInfoFlags.NONE, null);

    const sensorCandidates = [];

    let fileInfo;
    while ((fileInfo = hwmonEnumerator.next_file(null)) !== null) {
      const hwmonDirPath = `${hwmonPath}/${fileInfo.get_name()}`;
      const nameFilePath = `${hwmonDirPath}/name`;

      if (GLib.file_test(nameFilePath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
        const [success, nameBytes] = GLib.file_get_contents(nameFilePath);
        if (success) {
          const sensorName = new TextDecoder().decode(nameBytes).trim();
          const priority = sensorLabelPriority.findIndex(({ regex }) => regex.test(sensorName));
          if (priority !== -1) {
            sensorCandidates.push({ path: hwmonDirPath, priority, labels: sensorLabelPriority[priority].labels });
          }
        }
      }
    }

    sensorCandidates.sort((a, b) => a.priority - b.priority);

    for (const { path, labels } of sensorCandidates) {
      for (const label of labels) {
        const inputPath = findInputForLabel(path, label);
        if (inputPath) {
          console.log(`Using CPU temperature file: ${inputPath}`);
          return inputPath;
        }
      }
    }
  } catch (error) {
    console.error("Error determining temperature file path:", error);
  }

  console.error("No valid CPU temperature path found.");
  return null;
}

const tempFilePath = determineTempFilePath();

const cpuTemp = Variable("", {
  poll: [
    5000,
    () => {
      if (!tempFilePath) return "N/A";
      try {
        const [success, tempBytes] = GLib.file_get_contents(tempFilePath);
        if (!success) return "N/A";
        const temp = parseFloat(new TextDecoder().decode(tempBytes)) / 1000;
        return `${temp.toFixed(0)}°C`;
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
        size: 16,
      }),
      Widget.Label({
        class_name: "temperature-usage",
        label: cpuTemp.bind(),
      }),
    ],
  });
}
