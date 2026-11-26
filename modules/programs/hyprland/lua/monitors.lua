-- fallback monitor config
hl.monitor({
	output = "",
	mode = "highres",
	position = "auto",
	scale = "1",
})

if nix.monitors.secondary then
	-- set primary monitor for xwayland apps too.
	hl.on("monitor.layout_changed", function()
		hl.exec_cmd(nix.bin.xrandr .. " --output " .. nix.monitors.default .. " --primary")
	end)

	-- set workspaces to alternate between monitors when there are 2 monitors.
	for i = 1, 10 do
		local monitor = (i % 2 == 1) and nix.monitors.default or nix.monitors.secondary
		hl.workspace_rule({
			workspace = tostring(i),
			monitor = monitor,
		})
	end
end
