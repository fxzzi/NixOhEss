const hyprland = await Service.import("hyprland");

export const Workspaces = (monitorName) =>
  Widget.Box({
    class_name: "workspaces",
    children: hyprland.bind("workspaces").as((ws) =>
      ws
        .filter(({ monitor }) => monitor === monitorName)
        .sort((a, b) => a.name - b.name)
        .map(({ address, name }) =>
          Widget.Button({
            on_clicked: () => hyprland.dispatch.focus({ workspace: address }),
            child: Widget.Label(name),
            class_name: hyprland.active.workspace
              .bind("address")
              .as((activeAddress) =>
                activeAddress === address ? "focused" : "",
              ),
          }),
        ),
    ),
  });
