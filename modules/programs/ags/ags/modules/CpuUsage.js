let lastTotal = 0;
let lastIdle = 0;

const cpuUsage = Variable("", {
  poll: [
    2000,
    () => {
      try {
        const contents = Utils.readFile("/proc/stat");
        const [user, nice, system, idle, iowait, irq, softirq] = contents
          .split("\n")[0]
          .split(/\s+/)
          .slice(1)
          .map(Number);

        const currentIdle = idle + iowait;
        const currentTotal = user + nice + system + currentIdle + irq + softirq;

        const totalDiff = currentTotal - lastTotal;
        const idleDiff = currentIdle - lastIdle;

        lastTotal = currentTotal;
        lastIdle = currentIdle;

        const usage = totalDiff > 0 ? (100 * (totalDiff - idleDiff)) / totalDiff : 0;
        return `${Math.round(usage)}%`;
      } catch (error) {
        console.error("Error calculating CPU usage:", error);
        return "N/A";
      }
    },
  ],
});

export function CpuUsageWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "activity-outline-symbolic",
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        class_name: "cpu-usage",
        label: cpuUsage.bind(),
      }),
    ],
  });
}