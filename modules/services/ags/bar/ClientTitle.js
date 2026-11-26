import { IconLabel } from "../lib/IconLabel.js";

const hyprland = await Service.import("hyprland");

const title = hyprland.active.client.bind("title");

export const ClientTitleWidget = () =>
	IconLabel({
		visible: title.as(Boolean),
		icon: "app-window-outline-symbolic",
		label: title,
		labelProps: { truncate: "end" },
	});
