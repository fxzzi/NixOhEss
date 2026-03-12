const date = Variable("", {
  poll: [360000, () => {
    const now = new Date();
    return `${now.toLocaleDateString(undefined, { weekday: "short" })} ${String(now.getDate()).padStart(2, "0")}/${String(now.getMonth() + 1).padStart(2, "0")}`;
  }],
});

export function DateWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({ icon: "calendar-outline-symbolic", class_name: "icon", size: 16 }),
      Widget.Label({ class_name: "date", label: date.bind() }),
    ],
  });
}
