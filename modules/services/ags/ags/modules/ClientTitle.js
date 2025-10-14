const hyprland = await Service.import("hyprland");
const len = 96;

export const ClientTitleWidget = () => Widget.Label({
  class_name: "client-title",
  label: hyprland.active.client.bind("title").as(t => t.length > len ? `${t.substring(0, (len-3))}...` : t),
});
