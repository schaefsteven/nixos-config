{ config, pkgs, ... } :

{
  imports = [
    ./alacritty.nix
    ./bashmount.nix
    ./btop.nix
    ./firefox.nix
    ./gh-cli.nix
    ./git.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [

    # terminal apps
    cowsay
    dig
    fastfetch
    inxi
    jq
    lolcat
    nmap
    playerctl
    python3
    python312Packages.pip
    ranger
    sops
    tldr
    tree
    unzip
    xclip

    # desktop apps
    discord
    gimp
    google-chrome
    obsidian
    reaper
    spotify
    ungoogled-chromium
    xfce.thunar

    # desktop utilities
    feh
    flameshot
    gpick
    ksnip
    nitrogen
    pavucontrol
    qdirstat

    # other
    electron
  ];
}
