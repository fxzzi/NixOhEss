import { IconLabel } from "../lib/IconLabel.js";

const audio = await Service.import("audio");

function getVolumeIcon() {
  if (audio.speaker.is_muted) return "speaker-x-outline-symbolic";
  const v = audio.speaker.volume * 100;
  if (v >= 50) return "speaker-high-outline-symbolic";
  if (v > 0) return "speaker-low-outline-symbolic";
  return "speaker-none-outline-symbolic";
}

const changeVolume = (delta) => {
  const v = Math.round((audio.speaker.volume + delta) * 100) / 100;
  audio.speaker.volume = Math.min(1, Math.max(0, v));
};

export const VolumeWidget = () =>
  Widget.EventBox({
    on_primary_click_release: () =>
      (audio.speaker.is_muted = !audio.speaker.is_muted),
    on_scroll_up: () => changeVolume(0.01),
    on_scroll_down: () => changeVolume(-0.01),
    child: IconLabel({
      icon: Utils.watch(getVolumeIcon(), audio.speaker, getVolumeIcon),
      label: audio.speaker.bind("volume").as((v) => `${Math.round(v * 100)}%`),
    }),
  });
