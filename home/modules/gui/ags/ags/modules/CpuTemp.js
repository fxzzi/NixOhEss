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

function determineTempFilePath() {
  const baseHwmonPath = "/sys/class/hwmon";

  try {
    const directory = Gio.File.new_for_path(baseHwmonPath);
    const enumerator = directory.enumerate_children(
      "standard::name",
      Gio.FileQueryInfoFlags.NONE,
      null
    );

    let fileInfo;
    const hwmonDirs = [];

    // Collect all hwmon directories and their names
    while ((fileInfo = enumerator.next_file(null)) !== null) {
      const hwmonDirPath = `${baseHwmonPath}/${fileInfo.get_name()}`;
      const nameFilePath = `${hwmonDirPath}/name`;

      if (GLib.file_test(nameFilePath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
        const [success, nameBytes] = GLib.file_get_contents(nameFilePath);
        if (success) {
          const sensorName = new TextDecoder("utf-8").decode(nameBytes).trim();
          hwmonDirs.push({ path: hwmonDirPath, name: sensorName });
        }
      }
    }

    // Enforce priority by iterating over the priority list
    for (const { regex, labels } of sensorLabelPriority) {
      for (const { path, name } of hwmonDirs) {
        if (regex.test(name)) {
          for (const label of labels) {
            const inputPath = findInputForLabel(path, label);
            if (inputPath) {
              console.log(`Using CPU temperature file: ${inputPath}`);
              return inputPath;
            }
          }
        }
      }
    }
  } catch (error) {
    console.error("Error determining temperature file path:", error);
  }

  console.error("No valid CPU temperature path found.");
  return null;
}

function findInputForLabel(directory, label) {
  const tempFilesEnumerator = Gio.File.new_for_path(directory).enumerate_children(
    "standard::name",
    Gio.FileQueryInfoFlags.NONE,
    null
  );

  let tempFileInfo;
  while ((tempFileInfo = tempFilesEnumerator.next_file(null)) !== null) {
    const fileName = tempFileInfo.get_name();

    // Check for temp*_label files
    if (fileName.startsWith("temp") && fileName.endsWith("_label")) {
      const labelFilePath = `${directory}/${fileName}`;
      const [labelSuccess, labelBytes] = GLib.file_get_contents(labelFilePath);

      if (labelSuccess) {
        const fileLabel = new TextDecoder("utf-8").decode(labelBytes).trim();
        if (fileLabel === label) {
          // Derive the corresponding temp*_input file
          const inputFileName = fileName.replace("_label", "_input");
          const inputFilePath = `${directory}/${inputFileName}`;

          if (GLib.file_test(inputFilePath, GLib.FileTest.EXISTS | GLib.FileTest.IS_REGULAR)) {
            return inputFilePath;
          }
        }
      }
    }
  }
  return null;
}

// Example Usage
const tempFilePath = determineTempFilePath();

const cpuTemp = Variable("", {
  poll: [
    5000,
    () => {
      if (!tempFilePath) return "N/A";
      try {
        const [success, tempBytes] = GLib.file_get_contents(tempFilePath);
        const temp = success
          ? parseFloat(new TextDecoder("utf-8").decode(tempBytes)) / 1000
          : null;
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
