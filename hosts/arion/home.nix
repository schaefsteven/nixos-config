{ config, pkgs, ... }:

{
  home.stateVersion = "24.05"; # Should be set for each host seperately. Should not change after install.

  imports = [
    ../../modules/home-common.nix
    ../../modules/home-desktop.nix
  ];

  home.packages = with pkgs; [
    alacritty

    # terminal apps
    cowsay
    dig
    fastfetch
    inxi
    lolcat
    neovim
    python3
    python312Packages.pip
    sops
    thefuck
    xclip
    pandoc
    texliveTeTeX

    # desktop apps
    discord
    google-chrome
    obsidian
    orca-slicer
    ungoogled-chromium
    zoom-us

    # desktop utilities
    gpick
    pavucontrol
  ];

}
