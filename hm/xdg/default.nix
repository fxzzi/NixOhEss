{ ... }:
{
	home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    mime.enable = true;
		userDirs.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
				# browser stuff
        "application/xhtml+xml" = "librewolf.desktop";
        "text/html" = "librewolf.desktop";
        "text/xml" = "librewolf.desktop";
        "x-scheme-handler/ftp" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";

				"inode/directory" = "thunar.desktop";
      };
    };
  };
}
