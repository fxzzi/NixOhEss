hl.on("hyprland.start", function()
	-- set Hyprland to SCHED_RR scheduling policy
	-- also set RESET_ON_FORK flag so that child processes
	-- don't inherit the scheduling policy
	-- and set the priority to 1
	hl.exec_cmd("chrt -Rrp 1 $PPID")
end)

hl.on("hyprland.shutdown", function()
	-- discord literally craps itself and coredumps if the graphical env
	-- is shut down whilst it's still open. kill it to avoid the coredump.
	-- exec_cmd runs async, so to delay shutdown we need os.execute()
	os.execute("pgrep --quiet Discord && pkill -9 Discord")
end)
