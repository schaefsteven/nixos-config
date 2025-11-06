{ config, pkgs, lib, ... }:

{
  # i3
  services.xserver = {
    enable = true;
    deviceSection = ''Option "TearFree" "true"'';

    # Keyboard layout and mapping (Xmodmap replacement)
    xkb = {
      # disabled these for now until I can figure out how to exlude QMK 
      # options = builtins.concatStringsSep "," [
        # "ctrl:nocaps" # use Capslock as Ctrl
        # "shift:both_capslock" # double-shift for capslock
        # "altwin:swap_alt_win" # swap lwin and lalt
      # ];
      layout = "us";
      variant = "";
    };

    # I tried to make this work so that custom rules get applied to everything 
    # but my QMK keyboard, but alas, no worky. leaving this here in case I come 
    # back and try to fix it later for reference. 
    inputClassSections = [
      ''
        Identifier "General Keyboards" 
        MatchIsKeyboard "on"
        MatchVendor "Dell|dell|Logitech|logitech"
        Option "XkbOptions" "ctrl:nocaps,shift:both_capslock,altwin:swap_alt_win"
      ''
      ''
        Identifier "Framework Laptop Keyboard" 
        MatchIsKeyboard "on"
        MatchProduct "AT Translated Set 2 keyboard"
        Option "XkbOptions" "ctrl:nocaps,shift:both_capslock,altwin:swap_alt_win"
      ''
    ];

    desktopManager = {
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      # configFile moved to /hosts/<host>/i3.nix
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        acpi
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
}
