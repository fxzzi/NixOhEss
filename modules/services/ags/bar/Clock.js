import { IconLabel } from "../lib/IconLabel.js";

const pad = (n) => String(n).padStart(2, "0");

const time = Variable("", {
  poll: [1000, () => new Date().toTimeString().slice(0, 8)],
});

const date = Variable("", {
  poll: [
    60000,
    () => {
      const now = new Date();
      const day = now.toLocaleDateString(undefined, { weekday: "short" });
      return `${day} ${pad(now.getDate())}/${pad(now.getMonth() + 1)}`;
    },
  ],
});

export const TimeWidget = () =>
  IconLabel({
    icon: "clock-analog-outline-symbolic",
    label: time.bind(),
    className: "time",
  });

export const DateWidget = () =>
  IconLabel({
    icon: "calendar-outline-symbolic",
    label: date.bind(),
    className: "date",
  });
