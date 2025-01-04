{ ... }:
{
	programs.librewolf = {
		enable = true;
		settings = {
			"webgl.disabled" = false;  
			"privacy.resistFingerprinting" = false;  
			"privacy.clearOnShutdown.history" = false;  
			"privacy.clearOnShutdown.cookies" = false;  

			# Stop weirdness when relaunching browser sometimes  
			"browser.sessionstore.resume_from_crash" = false;  

			# nvidia-vaapi-driver  
			"media.ffmpeg.vaapi.enabled" = true;  
			"widget.dmabuf.force-enabled" = true;  

			"middlemouse.paste" = false;  
			"general.autoScroll" = true;  

			"layout.frame_rate" = -1;  

			"general.smoothScroll" = false;  

			"identity.fxaccounts.enabled" = true;  
		};
	};
}
