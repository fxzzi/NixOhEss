import Gdk from "gi://Gdk";
import GdkPixbuf from "gi://GdkPixbuf";
import GLib from "gi://GLib";
import Gtk from "gi://Gtk?version=3.0";
import System from "system";

const WALL_DIR = `${GLib.get_user_data_dir()}/walls`;
const CURRENT_WALL = `${GLib.get_user_state_dir()}/wallpaper`;
const THUMB_W = 320;
const THUMB_H = 180;
const IMAGE_RE = /\.(jpe?g|png|webp|gif|bmp|tiff?)$/i;

const listWalls = () => {
  const names = [];
  const dir = GLib.Dir.open(WALL_DIR, 0);
  let name;
  while ((name = dir.read_name())) if (IMAGE_RE.test(name)) names.push(name);
  dir.close();
  return names.sort((a, b) =>
    a.localeCompare(b, undefined, { sensitivity: "base", numeric: true }),
  );
};

const applyWall = (path) => {
  App.closeWindow("wall-picker");
  Utils.execAsync(["wallust-script", path]);
};

export function WallPicker() {
  let loader = 0;

  const grid = Widget.FlowBox({
    class_name: "walls",
    homogeneous: true,
    min_children_per_line: 1,
    max_children_per_line: 4,
    row_spacing: 8,
    column_spacing: 8,
    activate_on_single_click: true,
    valign: Gtk.Align.START,
  });
  grid.connect("child-activated", (_, child) =>
    applyWall(child.get_child().attribute),
  );

  const scroll = Widget.Scrollable({
    class_name: "wall-scroll",
    hscroll: "never",
    child: grid,
  });
  // keep the focused wall scrolled into view while navigating with arrows
  grid.set_focus_vadjustment(scroll.get_vadjustment());

  const open = () => {
    const active = GLib.file_read_link(CURRENT_WALL);

    const tiles = listWalls().map((name) => {
      const path = `${WALL_DIR}/${name}`;
      const image = new Gtk.Image({
        width_request: THUMB_W,
        height_request: THUMB_H,
      });
      grid.add(
        Widget.Box({
          class_names: path === active ? ["wall", "active"] : ["wall"],
          vertical: true,
          spacing: 4,
          attribute: path,
          children: [
            image,
            Widget.Label({
              label: name,
              truncate: "middle",
              max_width_chars: 30,
            }),
          ],
        }),
      );
      return { path, image };
    });
    grid.show_all();

    // focus the first wall so arrow keys work straight away
    const first = grid.get_child_at_index(0);
    if (first) {
      grid.select_child(first);
      first.grab_focus();
    }

    // decode one thumb per idle tick in grid order, so they pop in one by one
    // without freezing the picker; closing removes the rest
    const scale = grid.get_scale_factor();
    if (tiles.length)
      loader = GLib.idle_add(GLib.PRIORITY_LOW, () => {
        const { path, image } = tiles.shift();
        const pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
          path,
          THUMB_W * scale,
          THUMB_H * scale,
          true,
        );
        image.set_from_surface(
          Gdk.cairo_surface_create_from_pixbuf(pixbuf, scale, null),
        );
        if (tiles.length) return GLib.SOURCE_CONTINUE;
        loader = 0;
        return GLib.SOURCE_REMOVE;
      });
  };

  // drop the tiles and collect straight away so the thumbs don't linger in memory
  const close = () => {
    if (loader) GLib.source_remove(loader);
    loader = 0;
    grid.get_children().forEach((c) => c.destroy());
    System.gc();
  };

  return Widget.Window({
    name: "wall-picker",
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
          if (name === "wall-picker") visible ? open() : close();
        },
        "window-toggled",
      ),
  }).keybind("Escape", () => App.closeWindow("wall-picker"));
}
