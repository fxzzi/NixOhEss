import GObject from "gi://GObject";
import Gtk from "gi://Gtk?version=3.0";

// asks for no height, so tall glyphs can't stretch the bar.
// the child stays centred and overflows instead
const NoHeightBox = GObject.registerClass(
  class NoHeightBox extends Gtk.Box {
    vfunc_get_preferred_height() {
      return [0, 0];
    }
    vfunc_get_preferred_height_for_width() {
      return [0, 0];
    }
  },
);

// the icon + label pair most bar widgets are made of.
// icon, label and iconClass can be plain values or bindings, labelProps go to
// the label, and anything else is passed through to the outer box
export const IconLabel = ({
  icon,
  label,
  iconClass = "icon",
  labelProps = {},
  ...props
}) => {
  const labelBox = new NoHeightBox();
  labelBox.add(Widget.Label({ label, ...labelProps }));
  return Widget.Box({
    ...props,
    children: [
      Widget.Icon({ icon, class_name: iconClass, size: 16 }),
      labelBox,
    ],
  });
};
