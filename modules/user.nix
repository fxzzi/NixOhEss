{ config, pkgs, inputs, ... }: 
{
  users.users.faaris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Add to wheel for sudo access
    shell = pkgs.zsh; # Set shell to zsh
    packages = with pkgs; [
      librewolf
      nvtopPackages.nvidia
      bottom
      mpv
      obs-studio
      lxqt.pavucontrol-qt
      ffmpegthumbnailer
      bat
      eza
			fastfetch
			libsixel
			ncmpcpp
			mpd
			mpc
			syncthing
			mpd-discord-rpc
    ];
  };
  programs.zsh.enable = true;
  programs.zsh.histFile = "$XDG_STATE_HOME/zsh/history";
}
