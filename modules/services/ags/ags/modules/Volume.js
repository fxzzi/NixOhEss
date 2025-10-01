const audio = await Service.import("audio");

export function VolumeWidget() {
  const icons = {
    70: "audio-volume-high-symbolic",
    40: "audio-volume-medium-symbolic",
    1: "audio-volume-low-symbolic",
    0: "audio-volume-muted-symbolic",
  };

  function getIcon() {
    if (audio.speaker.is_muted) {
        return icons[0];
    }
    const volume = audio.speaker.volume * 100;
    if (volume >= 70) {
        return icons[70];
    }
    if (volume >= 40) {
        return icons[40];
    }
    if (volume > 0) {
        return icons[1];
    }
    return icons[0];
  }

  return Widget.Box({
    children: [
      Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
        class_name: "icon",
      }),
      Widget.Label({
        hexpand: true,
        label: audio.speaker
          .bind("volume")
          .as((v) => `${Math.round(v * 100)}%`),
        class_name: "bar-button-label volume",
      }),
    ],
  });
}
