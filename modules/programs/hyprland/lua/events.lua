hl.on("hyprland.shutdown", function()
  -- discord literally craps itself and coredumps if the graphical env
  -- is shut down whilst it's still open. kill it to avoid the coredump.
  -- exec_cmd runs async, so to delay shutdown we need os.execute()
  os.execute("pgrep --quiet Discord && pkill -9 Discord")
end)
