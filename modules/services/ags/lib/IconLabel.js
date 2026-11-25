import Pango from "gi://Pango";

// fixed line height so tall fallback glyphs (CJK, Thai, Tibetan...) in titles
// can't stretch the bar. GTK3 CSS has no line-height
const lineHeight = new Pango.AttrList();
lineHeight.insert(Pango.attr_line_height_new_absolute(20 * Pango.SCALE));

// the icon + label pair most bar widgets are made of.
// icon, label and iconClass can be plain values or bindings, labelProps go to
// the label, and anything else is passed through to the outer box
export const IconLabel = ({
  icon,
  label,
  iconClass = "icon",
  labelProps = {},
  ...props
}) =>
  Widget.Box({
    spacing: 4,
    ...props,
    children: [
      Widget.Icon({ icon, class_name: iconClass, size: 16 }),
      Widget.Label({ label, attributes: lineHeight, ...labelProps }),
    ],
  });
