{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    plugins = [ pkgs.tmuxPlugins.vim-tmux-navigator ];
    extraConfig = ''
      bind-key -n C-Tab next-window
    '';
  };
}
