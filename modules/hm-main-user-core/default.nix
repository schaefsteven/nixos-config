{ config, pkgs, ... } :

{
  imports = [
    ./alacritty.nix
    ./bashmount.nix
    ./btop.nix
    ./firefox.nix
    ./gh-cli.nix
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
    nmap
    python3
    python312Packages.pip
    ranger
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
    reaper
    spotify
    ungoogled-chromium

    # desktop utilities
    ksnip
    flameshot
    gpick
    pavucontrol

    # other
    electron
  ];
}
