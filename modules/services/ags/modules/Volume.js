const audio = await Service.import("audio");

function getVolumeIcon() {
  if (audio.speaker.is_muted) return "audio-volume-muted-symbolic";
  const v = audio.speaker.volume * 100;
  if (v >= 70) return "audio-volume-high-symbolic";
  if (v >= 40) return "audio-volume-medium-symbolic";
  if (v > 0)   return "audio-volume-low-symbolic";
  return "audio-volume-muted-symbolic";
}

export function VolumeWidget() {
  return Widget.Box({
    vertical: true,
    hpack: "center",
    children: [
      Widget.Icon({
        icon: Utils.watch(getVolumeIcon(), audio.speaker, getVolumeIcon),
        class_name: "icon",
        size: 20,
      }),
      Widget.Label({
        label: audio.speaker.bind("volume").as(v => `${Math.round(v * 100)}`),
        class_name: "metric-value volume",
        justification: "center",
      }),
      Widget.Label({
        class_name: "metric-unit",
        label: "%",
        justification: "center",
      }),
    ],
  });
}
