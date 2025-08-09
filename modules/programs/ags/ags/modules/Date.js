const date = Variable("", {
  poll: [
    360000,
    () => {
      const now = new Date();
      const day = now.toLocaleDateString(undefined, { weekday: "short" });
      const dayOfMonth = now.getDate().toString().padStart(2, "0");
      const month = (now.getMonth() + 1).toString().padStart(2, "0");
      return `${day} ${dayOfMonth}/${month}`;
    },
  ],
});

export function DateWidget() {
  return Widget.Box({
    children: [
      Widget.Icon({
        icon: "calendar-outline-symbolic",
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        class_name: "date",
        label: date.bind(),
      }),
    ],
  });
}