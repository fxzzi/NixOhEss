{ pkgs, ... }:
{
  users.users.faaris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Add to wheel for sudo access
    shell = pkgs.zsh; # Set shell to zsh
		
		# See: https://github.com/nix-community/home-manager/issues/108
		ignoreShellProgramCheck = true;
    
		packages = with pkgs; [
      librewolf
      nvtopPackages.nvidia
      bottom
      mpv
      obs-studio
      obs-studio-plugins.obs-vkcapture
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
      qbittorrent-enhanced
    ];
  };
  security.pam.services.faaris.gnupg.enable = true;
}
