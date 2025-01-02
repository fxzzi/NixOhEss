{ config, pkgs, inputs, ... }: 
{
  fonts.packages = with pkgs; [
    nerd-fonts.space-mono
    noto-fonts # Google Noto Fonts
    noto-fonts-emoji # Emoji Font
    noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
		# also grab apple fonts from flake
		inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    inputs.apple-fonts.packages.${pkgs.system}.ny
  ];
	fonts.fontconfig = {
			subpixel.rgba = "bgr";
			defaultFonts = {
					serif = [ "New York Medium" ];
					sansSerif = [ "SF Pro Text" ];
					monospace = [ "SpaceMono Nerd Font" ];
			};
	};
}
