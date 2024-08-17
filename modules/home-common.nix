{ config, pkgs, ... }:

{
  home.username = "usr";
  home.homeDirectory = "/home/usr";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    # ./zsh.nix
    ./btop.nix
    ./git.nix
  ];
}
