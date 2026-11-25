import Gdk from "gi://Gdk";
import Gio from "gi://Gio";

import { Workspaces } from "./bar/Workspaces.js";
import { ClientTitleWidget } from "./bar/ClientTitle.js";
import { TimeWidget, DateWidget } from "./bar/Clock.js";
import { BatteryWidget } from "./bar/Battery.js";
import { SysTrayWidget } from "./bar/SysTray.js";
import { VolumeWidget } from "./bar/Volume.js";
import { MpdWidget } from "./bar/Mpd.js";
import {
  CpuUsageWidget,
  CpuTempWidget,
  GpuTempWidget,
  MemUsageWidget,
} from "./bar/Stats.js";
import { WallPicker } from "./windows/WallPicker.js";
import { PowerMenu } from "./windows/PowerMenu.js";

// follows the visibility of the widget it separates, so hidden widgets
// don't leave a stray separator behind
const sep = (target) =>
  Widget.Label({
    label: "|",
    class_name: "sep",
    setup: (self) =>
      self.hook(
        target,
        () => (self.visible = target.visible),
        "notify::visible",
      ),
  });

const group = (children, props = {}) =>
  Widget.Box({ spacing: 10, children, ...props });

// CenterBox packs its start and end widgets with expand, so pin them to the edges
const section = (children, props) =>
  Widget.Box({ spacing: 8, children, ...props });

const Left = (monitorName) => {
  const title = ClientTitleWidget();
  return section([Workspaces(monitorName), sep(title), title], {
    hpack: "start",
  });
};

const Center = () =>
  group([TimeWidget(), DateWidget()], { class_name: "center" });

const Right = () => {
  const mpd = MpdWidget();
  const tray = SysTrayWidget();
  const volume = VolumeWidget();
  return section(
    [
      mpd,
      sep(mpd),
      tray,
      sep(tray),
      group([
        GpuTempWidget(),
        CpuTempWidget(),
        CpuUsageWidget(),
        MemUsageWidget(),
        BatteryWidget(),
      ]),
      sep(volume),
      volume,
    ],
    { hpack: "end" },
  );
};

const Bar = (gdkMonitor, monitorName) =>
  Widget.Window({
    name: `bar-${monitorName}`,
    class_name: "bar",
    gdkmonitor: gdkMonitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitorName),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

const hyprland = await Service.import("hyprland");
const display = Gdk.Display.get_default();

// match by connector name (DP-1 etc), since that's what hyprland reports
const getMonitorByName = (name) => {
  const screen = display.get_default_screen();
  for (let i = 0; i < display.get_n_monitors(); ++i) {
    if (screen.get_monitor_plug_name(i) === name) return display.get_monitor(i);
  }
  return null;
};

const hasBar = (name) => App.windows.some((w) => w.name === `bar-${name}`);

const addBar = (name) => {
  if (hasBar(name)) return;
  const gdkMonitor = getMonitorByName(name);
  if (gdkMonitor) App.addWindow(Bar(gdkMonitor, name));
};

// on monitor connects and disconnects, update only the affected bar
hyprland.connect("monitor-added", (_, name) => addBar(name));
hyprland.connect("monitor-removed", (_, name) => {
  if (hasBar(name)) App.removeWindow(`bar-${name}`);
});

App.config({
  style: "./style.css",
  icons: "./icons",
  // popups, only built the first time they're toggled with `ags -t <name>`
  lazyWindows: {
    "wall-picker": WallPicker,
    "power-menu": PowerMenu,
  },
});

// on startup, create bars for all monitors
hyprland.monitors.forEach(({ name }) => addBar(name));

// reload CSS when wallust updates colors
Utils.monitorFile(`${App.configDir}/colors_ags.css`, (_, event) => {
  if (event === Gio.FileMonitorEvent.CHANGES_DONE_HINT)
    App.applyCss(`${App.configDir}/style.css`, true);
});
