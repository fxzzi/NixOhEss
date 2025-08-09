const hyprland = await Service.import("hyprland");

export const ClientTitleWidget = () => Widget.Label({
  class_name: "client-title",
  label: hyprland.active.client.bind("title").as(t => t.length > 72 ? `${t.substring(0, 69)}...` : t),
});