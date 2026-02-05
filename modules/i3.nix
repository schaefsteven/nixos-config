{ config, pkgs, lib, ... }:

{
  # i3
  services.xserver = {
    enable = true;
    deviceSection = ''Option "TearFree" "true"'';

    # Keyboard layout and mapping (Xmodmap replacement)
    xkb = {
      # disabled these for now until I can figure out how to exlude QMK. Currently
      # just applying to all other vendors I use below in inputClassSections
      # options = builtins.concatStringsSep "," [
        # "ctrl:nocaps" # use Capslock as Ctrl
        # "shift:both_capslock" # double-shift for capslock
        # "altwin:swap_alt_win" # swap lwin and lalt
      # ];
      layout = "us";
      variant = "";
    };

    inputClassSections = [
      # For most keyboards (not QMK), Ctrl on Caps, Double-Shift Caps Lock, 
      # Swap Alt and Win
      ''
        Identifier "General Keyboards" 
        MatchIsKeyboard "on"
        MatchVendor "Dell|dell|Logitech|logitech|"
        Option "XkbOptions" "ctrl:nocaps,shift:both_capslock,altwin:swap_alt_win"
      ''
      # For Framework Laptop, Ctrl on Caps, Double-Shift Caps Lock, 
      # Swap Alt and Win
      ''
        Identifier "Framework Laptop Keyboard" 
        MatchIsKeyboard "on"
        MatchProduct "AT Translated Set 2 keyboard"
        Option "XkbOptions" "ctrl:nocaps,shift:both_capslock,altwin:swap_alt_win"
      ''
      # For Rii TV remote, swap alt and Win
      ''
        Identifier "Rii mini TV remote" 
        MatchIsKeyboard "on"
        MatchProduct "123 COM Smart Control"
        Option "XkbOptions" "altwin:swap_alt_win"
      ''
      # For Kensington Trackball, reverse scroll, remap back button
      # Natrual scroll is overridden by services.libinput.mouse.natrualScrolling,
      # so for now, I'm just using that instead, which applies to all mice.
      ''
        Identifier "Kensington Trackball"
        MatchIsPointer "on"
        MatchProduct "Kensington SlimBlade Pro Trackball(Wired) Kensington SlimBlade Pro Trackball(Wired)"
        Driver "libinput"
        Option "ButtonMapping" "1 8 3 4 5 6 7 2 9"
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

  # Reverse Scroll for Kensington Trackball.
  services.libinput.mouse.naturalScrolling = true;
}
