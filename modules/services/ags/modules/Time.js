const time = Variable("", {
  poll: [1000, () => new Date().toTimeString().slice(0, 8)],
});

export function TimeWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({ icon: "clock-analog-outline-symbolic", class_name: "icon", size: 16 }),
      Widget.Label({ class_name: "time", label: time.bind() }),
    ],
  });
}
