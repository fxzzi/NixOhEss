// the 16px icon + label pair most bar widgets are made of.
// icon, label and iconClass can be plain values or bindings;
// anything else is passed through to the outer box
export const IconLabel = ({ icon, label, className, iconClass = "icon", ...props }) =>
  Widget.Box({
    ...props,
    children: [
      Widget.Icon({ icon, class_name: iconClass, size: 16 }),
      Widget.Label({ class_name: className, label }),
    ],
  });
