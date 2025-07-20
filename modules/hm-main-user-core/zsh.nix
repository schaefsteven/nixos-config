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
      please = "sudo";
      py = "python3";
      tree = "tree --filesfirst";
      tuxsay = "cowsay -f tux";
      xclip = "xclip -selection clipboard";
    };
    oh-my-zsh = {
      enable = true;
      # theme = "gozilla";
      # plugins = ["git-prompt"];
    };
    initContent = ''
      fastfetch
      echo
      spaces="                                               "
      date +"''${spaces}%A, %B %d : %Y/%m/%d"

      # prompt

      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git*' formats "(%b)"
      precmd() {
        vcs_info
      }

      setopt prompt_subst

      # set var uath if we're on an ssh connection
      [[ $SSH_CONNECTION ]] && local uath='%F{red}%n@%M%f'

      PROMPT=''\'''${uath} %F{blue}%B%1~%b%f ''${vcs_info_msg_0_} %F{green}%B➜%b%f '
      '';
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
}

