const systemtray = await Service.import("systemtray");

export function SysTrayWidget() {
  return Widget.Box({
    class_name: "tray",
    vertical: true,
    hpack: "center",
    children: systemtray.bind("items").as(items =>
      items.map(item => Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon"), class_name: "trayicon", size: 20 }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      }))
    ),
  });
}
