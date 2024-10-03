{ config, pkgs, ... } :

{
  imports = [
    ./btop.nix
    ./firefox.nix
    ./git.nix
    ./zsh.nix
    ./bashmount.nix
  ];

  home.packages = with pkgs; [
    alacritty

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
