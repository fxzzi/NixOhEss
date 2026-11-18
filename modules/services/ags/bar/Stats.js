import { IconLabel } from "../lib/IconLabel.js";
import { findCpuTempFile, findGpuTempFile, formatTemp } from "../lib/sysfs.js";

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
const cpuTemp = Variable("", { poll: [5000, () => formatTemp(cpuTempFile)] });
const gpuTemp = Variable("", { poll: [5000, () => formatTemp(gpuTempFile)] });

export const CpuUsageWidget = () =>
  IconLabel({
    icon: "activity-outline-symbolic",
    label: cpuUsage.bind(),
    className: "cpu-usage",
  });

export const MemUsageWidget = () =>
  IconLabel({
    icon: "pie-chart-outline-symbolic",
    label: memUsage.bind(),
    className: "memory-usage",
  });

export const CpuTempWidget = () =>
  IconLabel({
    icon: "thermometer-outline-symbolic",
    label: cpuTemp.bind(),
    className: "temperature-usage",
  });

export const GpuTempWidget = () =>
  IconLabel({
    icon: "expansion-card-symbolic",
    label: gpuTemp.bind(),
    className: "temperature-usage",
  });
