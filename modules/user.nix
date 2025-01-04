{ pkgs, ... }:
{
  users.users.faaris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Add to wheel for sudo access
    shell = pkgs.zsh; # Set shell to zsh

    # See: https://github.com/nix-community/home-manager/issues/108
    ignoreShellProgramCheck = true;

    packages = with pkgs; [
      nvtopPackages.nvidia
      mpv
      lxqt.pavucontrol-qt
      ffmpegthumbnailer
      libsixel
      qbittorrent-enhanced
      librewolf
    ];
  };
}
