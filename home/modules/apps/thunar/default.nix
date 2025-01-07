{
  lib,
  pkgs,
  config,
  ...
}:
{
	options.apps.thunar.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the thunar file manager";
  };
  config = lib.mkIf config.apps.thunar.enable {
    home.file = {
      # Thunar quick actions
      "uca.xml" = {
        target = "${config.xdg.configHome}/Thunar/uca.xml";
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
          <action>
          	<icon>clipboard</icon>
          	<name>Copy File / Folder Path</name>
          	<submenu></submenu>
          	<unique-id>1653335357081852-1</unique-id>
          	<command>echo -n &apos;&quot;%f&quot;&apos; | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}</command>
          	<description></description>
          	<range></range>
          	<patterns>*</patterns>
          	<directories/>
          	<audio-files/>
          	<image-files/>
          	<other-files/>
          	<text-files/>
          	<video-files/>
          </action>
          <action>
          	<icon>foot</icon>
          	<name>Edit in Terminal</name>
          	<submenu></submenu>
          	<unique-id>1715762765914315-1</unique-id>
          	<command>${lib.getExe pkgs.foot} ${lib.getExe pkgs.neovim} %f</command>
          	<description></description>
          	<range>*</range>
          	<patterns>*</patterns>
          	<other-files/>
          	<text-files/>
          </action>
          <action>
          	<icon>folder-blue-script</icon>
          	<name>Launch Terminal here</name>
          	<submenu></submenu>
          	<unique-id>1715763119333224-2</unique-id>
          	<command>${lib.getExe pkgs.foot} -D %f</command>
          	<description></description>
          	<range>*</range>
          	<patterns>*</patterns>
          	<directories/>
          </action>
          <action>
          	<icon>utilities-terminal_su</icon>
          	<name>Edit as root</name>
          	<submenu></submenu>
          	<unique-id>1716201472079277-1</unique-id>
          	<command>${lib.getExe pkgs.foot} ${lib.getExe' pkgs.sudo "sudoedit"} %f</command>
          	<description></description>
          	<range>*</range>
          	<patterns>*</patterns>
          	<other-files/>
          	<text-files/>
          </action>
          </actions>
        '';
      };
    };
  };
}
