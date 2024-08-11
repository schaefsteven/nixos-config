{ config, pkgs, ... }:

{
  # i3
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''Option "TearFree" "true"'';

    # Keyboard layout and mapping
    xkb = {
      options = builtins.concatStringsSep "," [
        "ctrl:nocaps" # use Capslock as Ctrl
        "shift:both_capslock" # double-shift for capslock
        "altwin:swap_alt_win" # swap lwin and lalt
      ];
      layout = "us";
      variant = "";
    };

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
      # lightdm.background = "#000000"; # overridden by stylix
      setupCommands = ''
        LEFT='HDMI-A-1'
  	CENTER='DisplayPort-0'
  	RIGHT='HDMI-A-0'
  	${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --mode '3840x2160' --dpi 120 --scale 1 --primary
  	${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --rotate right --scale 1.25 --left-of $CENTER
  	${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --scale 1.25 --right-of $CENTER
  	${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --pos 0x0
  	${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --pos 1350x0
  	${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --pos 5190x0
      '';
    };
  
    windowManager.i3 = {
      enable = true;
      configFile = ../configs/i3config;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
}
