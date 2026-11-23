const systemtray = await Service.import("systemtray");

export function SysTrayWidget() {
  // visible lives on the outer box: setting children calls show_all(),
  // which would undo it if both were on the same box
  return Widget.Box({
    class_names: ["island", "tray"],
    visible: systemtray.bind("items").as((items) => items.length > 0),
    child: Widget.Box({
      children: systemtray.bind("items").as((items) =>
        items.map((item) =>
          Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon"), size: 16 }),
            on_primary_click_release: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
          }),
        ),
      ),
    }),
  });
}
