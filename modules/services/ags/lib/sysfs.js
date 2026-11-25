// finding and reading hardware sensors under /sys
import GLib from "gi://GLib";
import { listDir } from "./fs.js";

const read = (path) => Utils.readFile(path).trim();
const exists = (path) => GLib.file_test(path, GLib.FileTest.EXISTS);

// read a sensor's *_input file in °C, or -1 if unavailable
export const readTemp = (path) => (path ? Utils.temperature(path) : -1);

export const formatTemp = (t) => (t < 0 ? "N/A" : `${t.toFixed(0)}°C`);

// hwmon driver name -> the temp labels that mean "the CPU", best first
const sensorLabelPriority = [
  { regex: /^k10temp|^zenpower/, labels: ["Tdie", "Tctl"] },
  { regex: /^coretemp/, labels: ["Package id 0"] },
];

export function findCpuTempFile() {
  const hwmons = listDir("/sys/class/hwmon").map(
    (h) => `/sys/class/hwmon/${h}`,
  );
  for (const { regex, labels } of sensorLabelPriority)
    for (const path of hwmons.filter((p) => regex.test(read(`${p}/name`))))
      for (const label of labels)
        for (const f of listDir(path))
          if (
            f.startsWith("temp") &&
            f.endsWith("_label") &&
            read(`${path}/${f}`) === label
          )
            return `${path}/${f.replace("_label", "_input")}`;
  return null;
}

const gpuVendors = ["0x10de", "0x1002"]; // nvidia, amd

export function findGpuTempFile() {
  for (const dev of listDir("/sys/bus/pci/devices")) {
    const base = `/sys/bus/pci/devices/${dev}`;
    if (!gpuVendors.includes(read(`${base}/vendor`))) continue;
    const f = listDir(`${base}/hwmon`)
      .map((h) => `${base}/hwmon/${h}/temp1_input`)
      .find(exists);
    if (f) return f;
  }
  return null;
}
