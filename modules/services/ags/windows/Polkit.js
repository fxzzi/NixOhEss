const polkit = await Service.import("polkit");

export function Polkit() {
	const password = Widget.Entry({
		hexpand: true,
		visibility: false,
		placeholder_text: "Password",
		on_accept: (self) => {
			polkit.respond(self.text);
			self.text = "";
		},
	});

	polkit.connect("request", () => Utils.timeout(100, () => password.grab_focus()));

	const button = (label, on_clicked) =>
		Widget.Button({ class_name: "action", label, on_clicked });

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
				Widget.Box({
					hpack: "end",
					spacing: 4,
					children: [
						button("Cancel", () => polkit.cancel()),
						button("Authenticate", () => password.activate()),
					],
				}),
			],
		}),
	}).keybind("Escape", () => polkit.cancel());
}
