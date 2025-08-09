const memUsage = Variable("", {
  poll: [
    2000,
    () => {
      try {
        const meminfo = Utils.readFile("/proc/meminfo");
        const totalMatch = meminfo.match(/MemTotal:\s+(\d+)/);
        const availableMatch = meminfo.match(/MemAvailable:\s+(\d+)/);

        if (!totalMatch || !availableMatch)
          throw new Error("Failed to parse /proc/meminfo");

        const totalRamKiB = parseInt(totalMatch[1], 10);
        const availableRamKiB = parseInt(availableMatch[1], 10);
        const usedRamGiB = (totalRamKiB - availableRamKiB) / (1024 * 1024);

        return `${usedRamGiB.toFixed(2)}GiB`;
      } catch (error) {
        console.error("Error calculating RAM usage:", error);
        return "N/A";
      }
    },
  ],
});

export function MemUsageWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "pie-chart-outline-symbolic",
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        class_name: "memory-usage",
        label: memUsage.bind(),
      }),
    ],
  });
}
