import { IconLabel } from "../lib/IconLabel.js";

const mpris = await Service.import("mpris");

const getPlayer = () => mpris.getPlayer("org.mpris.MediaPlayer2.mpd");

const state = Variable(null);

const update = () => {
  const player = getPlayer();
  if (!player || player.play_back_status === "Stopped") {
    state.value = null;
    return;
  }
  const artists = player.track_artists.filter(Boolean).join(", ");
  const title = player.track_title;
  state.value = {
    paused: player.play_back_status !== "Playing",
    label: artists ? `${artists} - ${title}` : title,
  };
};

mpris.connect("changed", update);
update();

const paused = state.bind().as((s) => Boolean(s?.paused));

export const MpdWidget = () =>
  Widget.EventBox({
    visible_window: false,
    visible: state.bind().as(Boolean),
    on_primary_click_release: () => getPlayer()?.playPause(),
    on_scroll_up: () => getPlayer()?.previous(),
    on_scroll_down: () => getPlayer()?.next(),
    child: IconLabel({
      class_name: paused.as((p) => (p ? "paused" : "")),
      icon: paused.as((p) =>
        p ? "media-playback-pause-symbolic" : "media-playback-start-symbolic",
      ),
      label: state.bind().as((s) => s?.label ?? ""),
      labelProps: { truncate: "end" },
    }),
  });
