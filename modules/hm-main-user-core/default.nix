{ config, pkgs, ... } :

{
  imports = [
    ./alacritty.nix
    ./bashmount.nix
    ./btop.nix
    ./firefox.nix
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [

    # terminal apps
    cowsay
    dig
    fastfetch
    inxi
    lolcat
    python3
    python312Packages.pip
    sops
    thefuck
    tldr
    tree
    unzip
    xclip

    # desktop apps
    discord
    gimp
    google-chrome
    obsidian
    spotify
    ungoogled-chromium

    # desktop utilities
    flameshot
    gpick
    pavucontrol
  ];
}
