import App from "resource:///com/github/Aylur/ags/app.js";
import Gdk from "gi://Gdk";
import GdkPixbuf from "gi://GdkPixbuf";
import Gio from "gi://Gio";
import GLib from "gi://GLib";
import Gtk from "gi://Gtk?version=3.0";

export const WALL_PICKER = "wall-picker";

const WALL_DIR = `${GLib.get_user_data_dir()}/walls`;
const CURRENT_WALL = `${GLib.get_user_state_dir()}/wallpaper`;
const THUMB_W = 320;
const THUMB_H = 180;
const IMAGE_RE = /\.(jpe?g|png|webp|gif|bmp|tiff?)$/i;

const listWalls = () => {
  const walls = [];
  try {
    const enumerator = Gio.File.new_for_path(WALL_DIR).enumerate_children(
      "standard::name,standard::type",
      Gio.FileQueryInfoFlags.NONE,
      null,
    );
    let info;
    while ((info = enumerator.next_file(null))) {
      const name = info.get_name();
      if (info.get_file_type() !== Gio.FileType.REGULAR || !IMAGE_RE.test(name))
        continue;
      walls.push({ name, path: `${WALL_DIR}/${name}` });
    }
    enumerator.close(null);
  } catch (e) {
    console.error(`wall-picker: can't read ${WALL_DIR}: ${e}`);
  }
  return walls.sort((a, b) => a.name.localeCompare(b.name));
};

const currentWall = () => {
  try {
    return GLib.file_read_link(CURRENT_WALL);
  } catch {
    return null;
  }
};

// decode a wall into a thumbnail sized pixbuf, off the main thread
const loadThumb = (path, scale) =>
  new Promise((resolve, reject) => {
    Gio.File.new_for_path(path).read_async(GLib.PRIORITY_LOW, null, (file, res) => {
      let stream;
      try {
        stream = file.read_finish(res);
      } catch (e) {
        reject(e);
        return;
      }
      GdkPixbuf.Pixbuf.new_from_stream_at_scale_async(
        stream,
        THUMB_W * scale,
        THUMB_H * scale,
        true,
        null,
        (_, r) => {
          try {
            resolve(GdkPixbuf.Pixbuf.new_from_stream_finish(r));
          } catch (e) {
            reject(e);
          }
          stream.close_async(GLib.PRIORITY_LOW, null, null);
        },
      );
    });
  });

// load thumbs one at a time in grid order, so they pop in one by one instead of
// all decoding at once and showing up together. reopening the picker bumps
// `generation`, which stops a load still running from the previous open
let generation = 0;
const loadThumbs = async (walls, scale) => {
  const gen = ++generation;
  for (const { path, image } of walls) {
    try {
      const pixbuf = await loadThumb(path, scale);
      if (gen !== generation) return;
      // surface with the right scale factor so thumbs are crisp on HiDPI
      image.set_from_surface(Gdk.cairo_surface_create_from_pixbuf(pixbuf, scale, null));
    } catch (e) {
      if (gen !== generation) return;
      console.error(`wall-picker: can't load ${path}: ${e}`);
    }
  }
};

const applyWall = (path) => {
  App.closeWindow(WALL_PICKER);
  Utils.execAsync(["wallust-script", path]).catch((e) =>
    console.error(`wall-picker: ${e}`),
  );
};

const WallTile = (wall, active) =>
  Widget.Box({
    class_names: active ? ["wall", "active"] : ["wall"],
    vertical: true,
    spacing: 4,
    attribute: wall,
    children: [
      wall.image,
      Widget.Label({
        label: wall.name,
        truncate: "middle",
        max_width_chars: 30,
      }),
    ],
  });

export function WallPicker() {
  const grid = Widget.FlowBox({
    class_name: "walls",
    homogeneous: true,
    min_children_per_line: 1,
    max_children_per_line: 4,
    row_spacing: 8,
    column_spacing: 8,
    selection_mode: Gtk.SelectionMode.SINGLE,
    activate_on_single_click: true,
    valign: Gtk.Align.START,
  });
  grid.connect("child-activated", (_, child) =>
    applyWall(child.get_child().attribute.path),
  );

  const scroll = Widget.Scrollable({
    class_name: "wall-scroll",
    hscroll: "never",
    vscroll: "automatic",
    child: grid,
  });
  // keep the focused wall scrolled into view while navigating with arrows
  grid.set_focus_vadjustment(scroll.get_vadjustment());

  const refresh = () => {
    const scale = grid.get_scale_factor();
    const active = currentWall();
    const walls = listWalls().map((wall) => ({
      ...wall,
      image: new Gtk.Image({ width_request: THUMB_W, height_request: THUMB_H }),
    }));

    grid.get_children().forEach((c) => c.destroy());
    for (const wall of walls) grid.add(WallTile(wall, wall.path === active));
    grid.show_all();
    loadThumbs(walls, scale);

    // start at the top, focused so arrow keys work straight away
    const first = grid.get_child_at_index(0);
    if (first) {
      grid.select_child(first);
      first.grab_focus();
    }
  };

  return Widget.Window({
    name: WALL_PICKER,
    class_name: "wall-picker",
    layer: "overlay",
    exclusivity: "ignore",
    keymode: "exclusive",
    visible: false,
    // wrapped in a box so the shared `window > box` styling applies
    child: Widget.Box({ children: [scroll] }),
    setup: (self) =>
      self.hook(
        App,
        (_, name, visible) => {
          if (name === WALL_PICKER && visible) refresh();
        },
        "window-toggled",
      ),
  }).keybind("Escape", () => App.closeWindow(WALL_PICKER));
}
