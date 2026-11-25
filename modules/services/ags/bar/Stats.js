import { IconLabel } from "../lib/IconLabel.js";
import {
  findCpuTempFile,
  findGpuTempFile,
  formatTemp,
  readTemp,
} from "../lib/sysfs.js";

const cpuTempFile = findCpuTempFile();
const gpuTempFile = findGpuTempFile();

// used = MemTotal - MemAvailable, in KiB
const memUsedKiB = () => {
  const info = Utils.readFile("/proc/meminfo");
  const get = (key) => Number(info.match(new RegExp(`${key}:\\s+(\\d+)`))[1]);
  return get("MemTotal") - get("MemAvailable");
};

const cpuUsage = Variable("", {
  poll: [2000, () => `${Math.round(Utils.cpuUsage() * 100)}%`],
});
const memUsage = Variable("", {
  poll: [2000, () => `${(memUsedKiB() / (1024 * 1024)).toFixed(2)}GiB`],
});
const cpuTemp = Variable(-1, { poll: [5000, () => readTemp(cpuTempFile)] });
const gpuTemp = Variable(-1, { poll: [5000, () => readTemp(gpuTempFile)] });

const thermometerIcon = (t) => {
  if (t >= 80) return "thermometer-hot-outline-symbolic";
  if (t >= 0 && t < 50) return "thermometer-cold-outline-symbolic";
  return "thermometer-outline-symbolic";
};

export const CpuUsageWidget = () =>
  IconLabel({
    icon: "activity-outline-symbolic",
    label: cpuUsage.bind(),
  });

export const MemUsageWidget = () =>
  IconLabel({
    icon: "pie-chart-outline-symbolic",
    label: memUsage.bind(),
  });

export const CpuTempWidget = () =>
  IconLabel({
    icon: cpuTemp.bind().as(thermometerIcon),
    label: cpuTemp.bind().as(formatTemp),
  });

export const GpuTempWidget = () =>
  IconLabel({
    icon: "graphics-card-outline-symbolic",
    label: gpuTemp.bind().as(formatTemp),
  });
