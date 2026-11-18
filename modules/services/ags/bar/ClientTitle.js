const hyprland = await Service.import("hyprland");

export const ClientTitleWidget = () =>
  Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client.bind("title"),
    truncate: "end",
    max_width_chars: 96,
  });
