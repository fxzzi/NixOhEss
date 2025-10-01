import GTop from "gi://GTop";

let lastTotal = 0;
let lastIdle = 0;

const cpu = new GTop.glibtop_cpu();

const cpuUsage = Variable("", {
  poll: [
    2000,
    () => {
      try {
        GTop.glibtop_get_cpu(cpu);

        const currentTotal = cpu.total;
        const currentIdle = cpu.idle + cpu.iowait;

        const totalDiff = currentTotal - lastTotal;
        const idleDiff = currentIdle - lastIdle;

        lastTotal = currentTotal;
        lastIdle = currentIdle;

        const usage = totalDiff > 0 ? (100 * (totalDiff - idleDiff)) / totalDiff : 0;
        return `${Math.round(usage)}%`;
      } catch (error) {
        console.error("Error calculating CPU usage", error);
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
