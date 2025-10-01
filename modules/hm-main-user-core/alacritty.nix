{ config, pkgs, ... }:

let 
# Use this to set the "scroll speed" of Ctrl+Shift+k/j in number of lines.
# It creates multiple bindings in the config file, which is the only way I
# know of to control the number of lines scrolled by the action.
scrollSpeed = 8;

scrollLineUp = {
  key = "K";
  mods = "Control|Shift";
  action = "ScrollLineUp";
};
scrollLineDown = {
  key = "J";
  mods = "Control|Shift";
  action = "ScrollLineDown";
};

  scrollBindings = builtins.concatLists [
  (builtins.genList (_: scrollLineUp ) scrollSpeed)
(builtins.genList (_: scrollLineDown ) scrollSpeed)
  ];
  in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
      keyboard.bindings = builtins.concatLists [
        [
          {
            key = "N";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
          { 
            key = "U";
            mods = "Control|Shift";
            action = "ScrollHalfPageUp";
          }
          { 
            key = "D";
            mods = "Control|Shift";
            action = "ScrollHalfPageDown";
          }
          # pass through ctrl-tab for tmux
          {
            key = "Tab";
            mods = "Control";
            chars = "\\u001b[27;5;9~";
          }
          {
            key = "Tab";
            mods = "Control|Shift";
            chars = "\\u001b[27;6;9~";
          }
        ]

          scrollBindings

          ];
# Hint Mode - Default keybind collides with my desired ScrollHalfPageUp
# For some reason, in order to change the keybind, I seem to have to completely
# re-define it. See https://alacritty.org/config-alacritty.html
        hints.enabled = [
        {
          binding = { key = "H"; mods = "Control|Shift"; };
          command = "xdg-open";
          hyperlinks = true;
          post_processing = true;
          persist = false;
          mouse.enabled = true;
          regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
        }
        ];
    };
  };
}
