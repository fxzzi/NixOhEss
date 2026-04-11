const battery = await Service.import("battery");

export const BatteryWidget = () => Widget.Box({
  visible: battery.bind("available"),
  vertical: true,
  hpack: "center",
  children: [
    Widget.Icon({
      icon: battery.bind("icon-name"),
      class_name: battery.bind("charging").as(ch => ch ? "charging icon" : "icon"),
      size: 20,
    }),
    Widget.Label({
      class_name: "metric-value battery",
      label: battery.bind("percent").as(p => `${p}`),
      justification: "center",
    }),
    Widget.Label({
      class_name: "metric-unit",
      label: "%",
      justification: "center",
    }),
  ],
});
