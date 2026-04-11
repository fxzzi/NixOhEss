const date = Variable("", {
  poll: [360000, () => {
    const now = new Date();
    const weekday = now.toLocaleDateString(undefined, { weekday: "short" });
    const day = now.getDate();
    const month = now.toLocaleDateString(undefined, { month: "short" });
    const suffix = day % 10 === 1 && day % 100 !== 11
      ? "st"
      : day % 10 === 2 && day % 100 !== 12
        ? "nd"
        : day % 10 === 3 && day % 100 !== 13
          ? "rd"
          : "th";
    return `${weekday}\n${day}${suffix}\n${month}`;
  }],
});

export function DateWidget() {
  return Widget.Box({
    vertical: true,
    hpack: "center",
    children: [
      Widget.Icon({ icon: "calendar-outline-symbolic", class_name: "icon", size: 20 }),
      Widget.Label({ class_name: "date", label: date.bind(), justification: "center" }),
    ],
  });
}
