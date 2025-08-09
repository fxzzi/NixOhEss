const hyprland = await Service.import("hyprland");

export const Workspaces = (monitorName) => Widget.Box({
  class_name: "workspaces",
  children: hyprland.bind("workspaces").as(ws => ws
    .filter(({ monitor }) => monitor === monitorName)
    .sort((a, b) => a.id - b.id)
    .map(({ id }) => Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(`${id}`),
      class_name: hyprland.active.workspace.bind("id").as(activeId => activeId === id ? "focused" : ""),
    }))),
});