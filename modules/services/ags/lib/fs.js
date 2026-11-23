import Gio from "gi://Gio";

// names of the entries in a directory, or [] if it can't be read
export function listDir(path) {
  try {
    const iter = Gio.File.new_for_path(path).enumerate_children(
      "standard::name",
      Gio.FileQueryInfoFlags.NONE,
      null,
    );
    const names = [];
    let info;
    while ((info = iter.next_file(null)) !== null) names.push(info.get_name());
    return names;
  } catch (e) {
    return [];
  }
}
