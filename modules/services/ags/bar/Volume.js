import { IconLabel } from "../lib/IconLabel.js";

const audio = await Service.import("audio");

function getVolumeIcon() {
  if (audio.speaker.is_muted) return "audio-volume-muted-symbolic";
  const v = audio.speaker.volume * 100;
  if (v >= 70) return "audio-volume-high-symbolic";
  if (v >= 40) return "audio-volume-medium-symbolic";
  if (v > 0) return "audio-volume-low-symbolic";
  return "audio-volume-muted-symbolic";
}

export const VolumeWidget = () =>
  IconLabel({
    hexpand: true,
    icon: Utils.watch(getVolumeIcon(), audio.speaker, getVolumeIcon),
    label: audio.speaker.bind("volume").as((v) => `${Math.round(v * 100)}%`),
    className: "bar-button-label volume",
  });
