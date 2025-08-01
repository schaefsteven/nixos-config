{ config, pkgs, lib, ... }:

let
  i3ConfigFiles = [
    ../configs/i3config
    ../configs/prepend
  ];
in {
  # i3
  services.xserver = {
    enable = true;
    deviceSection = ''Option "TearFree" "true"'';

    # Keyboard layout and mapping (Xmodmap replacement)
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
   
    windowManager.i3 = {
      enable = true;
      # configFile = ../configs/i3config;
      configFile = pkgs.writeText "i3config" (lib.concatStringsSep "\n" (map (f: builtins.readFile f) i3ConfigFiles));
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
