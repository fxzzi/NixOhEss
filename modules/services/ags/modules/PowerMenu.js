import App from "resource:///com/github/Aylur/ags/app.js";

export const POWER_MENU = "power-menu";

const actions = [
  {
    label: "Shutdown",
    key: "s",
    icon: "power-outline-symbolic",
    cmd: ["systemctl", "poweroff"],
  },
  {
    label: "Reboot",
    key: "r",
    icon: "restart-outline-symbolic",
    cmd: ["systemctl", "reboot"],
  },
  {
    label: "Suspend",
    key: "u",
    icon: "sleep-outline-symbolic",
    cmd: ["systemctl", "suspend"],
  },
  {
    label: "Logout",
    key: "e",
    icon: "logout-outline-symbolic",
    cmd: ["hyprctl", "dispatch", "hl.dsp.exit()"],
  },
];

const run = ({ cmd }) => {
  App.closeWindow(POWER_MENU);
  Utils.execAsync(cmd).catch((e) => console.error(`power-menu: ${e}`));
};

const ActionButton = (action) =>
  Widget.Button({
    class_name: "action",
    on_clicked: () => run(action),
    child: Widget.Box({
      vertical: true,
      spacing: 8,
      children: [
        Widget.Icon({ icon: action.icon, size: 44, class_name: "icon" }),
        Widget.Label({ label: action.label }),
        Widget.Label({
          class_name: "key",
          label: `[${action.key.toUpperCase()}]`,
        }),
      ],
    }),
  });

export function PowerMenu() {
  const buttons = actions.map(ActionButton);

  const win = Widget.Window({
    name: POWER_MENU,
    class_name: "power-menu",
    layer: "overlay",
    exclusivity: "ignore",
    keymode: "exclusive",
    visible: false,
    child: Widget.Box({
      spacing: 4,
      children: buttons,
    }),
    // focus the first button on open, so arrows + enter work too
    setup: (self) =>
      self.hook(
        App,
        (_, name, visible) => {
          if (name === POWER_MENU && visible) buttons[0].grab_focus();
        },
        "window-toggled",
      ),
  }).keybind("Escape", () => App.closeWindow(POWER_MENU));

  for (const action of actions) win.keybind(action.key, () => run(action));
  return win;
}
