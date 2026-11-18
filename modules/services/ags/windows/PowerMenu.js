const hyprland = await Service.import("hyprland");

const actions = [
  {
    label: "Shutdown",
    key: "s",
    icon: "power-outline-symbolic",
    exec: () => Utils.execAsync(["systemctl", "poweroff"]),
  },
  {
    label: "Reboot",
    key: "r",
    icon: "restart-outline-symbolic",
    exec: () => Utils.execAsync(["systemctl", "reboot"]),
  },
  {
    label: "Suspend",
    key: "u",
    icon: "sleep-outline-symbolic",
    exec: () => Utils.execAsync(["systemctl", "suspend"]),
  },
  {
    label: "Logout",
    key: "e",
    icon: "logout-outline-symbolic",
    exec: () => hyprland.dispatch.exit(),
  },
];

const run = (exec) => {
  App.closeWindow("power-menu");
  exec();
};

const ActionButton = ({ label, key, icon, exec }) =>
  Widget.Button({
    class_name: "action",
    on_clicked: () => run(exec),
    child: Widget.Box({
      vertical: true,
      spacing: 8,
      children: [
        Widget.Icon({ icon, size: 44, class_name: "icon" }),
        Widget.Label({ label }),
        Widget.Label({ class_name: "key", label: `[${key.toUpperCase()}]` }),
      ],
    }),
  });

export function PowerMenu() {
  const buttons = actions.map(ActionButton);

  const win = Widget.Window({
    name: "power-menu",
    class_name: "power-menu",
    layer: "overlay",
    exclusivity: "ignore",
    keymode: "exclusive",
    visible: false,
    child: Widget.Box({ spacing: 4, children: buttons }),
    // focus the first button on open, so arrows + enter work too
    setup: (self) =>
      self.hook(
        self,
        () => self.visible && buttons[0].grab_focus(),
        "notify::visible",
      ),
  }).keybind("Escape", () => App.closeWindow("power-menu"));

  for (const { key, exec } of actions) win.keybind(key, () => run(exec));
  return win;
}
