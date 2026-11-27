const polkit = await Service.import("polkit");

export function Polkit() {
	const password = Widget.Entry({
		visibility: false,
		placeholder_text: "Password",
		on_accept: (self) => polkit.respond(self.text),
	});

	polkit.connect("request", () => (password.text = ""));

	return Widget.Window({
		name: "polkit",
		class_name: "polkit",
		layer: "overlay",
		exclusivity: "ignore",
		keymode: "exclusive",
		visible: polkit.bind("active"),
		child: Widget.Box({
			vertical: true,
			spacing: 10,
			children: [
				Widget.Label({ class_name: "title", label: "Authentication Required" }),
				Widget.Label({
					wrap: true,
					max_width_chars: 48,
					label: polkit.bind("current-request").as((r) => r?.message ?? ""),
				}),
				password,
			],
		}),
	}).keybind("Escape", () => polkit.cancel());
}
