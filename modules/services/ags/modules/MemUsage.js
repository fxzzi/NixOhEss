import GTop from "gi://GTop";

const mem = new GTop.glibtop_mem();

const memUsage = Variable("", {
  poll: [
    2000,
    () => {
      try {
        GTop.glibtop_get_mem(mem);
        const usedRamGiB = mem.user / (1024 * 1024 * 1024);
        return `${usedRamGiB.toFixed(1)}`;
      } catch (error) {
        console.error("Error calculating RAM usage", error);
        return "N/A";
      }
    },
  ],
});

export function MemUsageWidget() {
  return Widget.Box({
    vertical: true,
    hpack: "center",
    children: [
      Widget.Icon({ icon: "pie-chart-outline-symbolic", class_name: "icon", size: 20 }),
      Widget.Label({
        class_name: "metric-value memory-usage",
        label: memUsage.bind(),
        justification: "center",
      }),
      Widget.Label({
        class_name: "metric-unit",
        label: memUsage.bind().as(v => v === "N/A" ? "" : "GiB"),
        justification: "center",
      }),
    ],
  });
}
