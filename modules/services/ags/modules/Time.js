const time = Variable("", {
  poll: [1000, () => {
    const [hh, mm, ss] = new Date().toTimeString().slice(0, 8).split(":");
    return `${hh}\n${mm}\n${ss}`;
  }],
});

export function TimeWidget() {
  return Widget.Box({
    vertical: true,
    hpack: "center",
    children: [
      Widget.Icon({ icon: "clock-analog-outline-symbolic", class_name: "icon", size: 20 }),
      Widget.Label({ class_name: "time", label: time.bind(), justification: "center" }),
    ],
  });
}
