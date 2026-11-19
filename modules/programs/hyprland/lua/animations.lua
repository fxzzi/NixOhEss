for name, points in pairs({
  easeOutQuint = { { 0.23, 1 }, { 0.32, 1 } },
  easeInOutCubic = { { 0.65, 0.05 }, { 0.36, 1 } },
  linear = { { 0, 0 }, { 1, 1 } },
  almostLinear = { { 0.5, 0.5 }, { 0.75, 1 } },
  quick = { { 0.15, 0 }, { 0.1, 1 } },
}) do
  hl.curve(name, {
    type = "bezier",
    points = points,
  })
end

for _, a in ipairs({
  { "windowsIn", true, 3, "easeOutQuint", "slide" },
  { "windowsOut", true, 3, "easeOutQuint", "slide" },
  { "windowsMove", true, 3, "easeOutQuint" },
  { "layersIn", true, 4, "easeOutQuint", "fade" },
  { "layersOut", true, 1.5, "linear", "fade" },
  { "fadeIn", true, 1.2, "almostLinear" },
  { "fadeOut", true, 2, "almostLinear" },
  { "fadeSwitch", true, 1.2, "almostLinear" },
  { "fadeShadow", true, 1.2, "almostLinear" },
  { "fadeDim", true, 1.2, "almostLinear" },
  { "fadeLayers", true, 1.4, "linear" },
  { "fadePopups", true, 2, "linear" },
  { "border", true, 5, "easeOutQuint" },
  { "specialWorkspace", true, 3, "quick", "fade" },
  { "zoomFactor", true, 4, "quick" },
  -- wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
  -- and it will look like windows are moving into each other across the monitors.
  { "workspaces", true, 4, "easeOutQuint", nix.multiMonitor and "slidevert" or "slide" },
  -- disable the bootup animation
  { "monitorAdded", false },
}) do
  hl.animation({
    leaf = a[1],
    enabled = a[2],
    speed = a[3],
    bezier = a[4],
    style = a[5],
  })
end
