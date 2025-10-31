import GTop from "gi://GTop";

const mem = new GTop.glibtop_mem();

const memUsage = Variable("", {
  poll: [
    2000,
    () => {
      try {
        GTop.glibtop_get_mem(mem);
        const usedRamGiB = mem.user / (1024 * 1024 * 1024);
        return `${usedRamGiB.toFixed(2)}GiB`;
      } catch (error) {
        console.error("Error calculating RAM usage", error);
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
        size: 16,
      }),
      Widget.Label({
        class_name: "memory-usage",
        label: memUsage.bind(),
      }),
    ],
  });
}
