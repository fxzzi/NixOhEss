const battery = await Service.import("battery");

export const BatteryWidget = () => Widget.Box({
  visible: battery.bind("available"),
  children: [
    Widget.Icon({
      icon: battery.bind("icon-name"),
      class_name: battery.bind("charging").as(ch => ch ? "charging icon" : "icon"),
    }),
    Widget.Label({
      class_name: "battery",
      label: battery.bind("percent").as(p => `${p}%`),
    }),
  ],
});