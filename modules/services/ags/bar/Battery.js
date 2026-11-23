import { IconLabel } from "../lib/IconLabel.js";

const battery = await Service.import("battery");

export const BatteryWidget = () =>
  IconLabel({
    visible: battery.bind("available"),
    icon: battery.bind("icon-name"),
    iconClass: battery
      .bind("charging")
      .as((ch) => (ch ? "charging icon" : "icon")),
    label: battery.bind("percent").as((p) => `${p}%`),
  });
