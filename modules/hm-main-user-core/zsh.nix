{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      gaac = "git add . && git commit";
      la = "ls -alhog --group-directories-first";
      ll = "ls -lhog --group-directories-first";
      nivm = "nvim";
      nixgit = "git -C ~/.nix";
      nrs = "sudo nixos-rebuild switch --flake ~/.nix";
      py = "python3";
      tree = "tree --filesfirst";
      tuxsay = "cowsay -f tux";
      xclip = "xclip -selection clipboard";
    };
    oh-my-zsh = {
      enable = true;
      theme = "gozilla";
      plugins = ["git" "thefuck"];
    };
    initExtra = ''
      fastfetch
      echo
      spaces="                                               "
      date +"''${spaces}%A, %B %d : %Y/%m/%d"
      '';
  };
}
