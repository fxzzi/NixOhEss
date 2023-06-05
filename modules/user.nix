{ config, pkgs, inputs, ... }: 
{
  users.users.faaris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Add to wheel for sudo access
    shell = pkgs.zsh; # Set shell to zsh
    packages = with pkgs; [
      librewolf
      nvtop-nvidia
      bottom
      macchina
      pamixer
      mpv
      obs-studio
      kitty
      pavucontrol
      gamemode
      ffmpegthumbnailer
      bat
      exa
    ];
  };
  programs.zsh.enable = true;
  programs.zsh.histFile = "$XDG_STATE_HOME/zsh/history";
}
