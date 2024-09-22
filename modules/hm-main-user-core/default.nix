{ config, pkgs, ... } :

{
  imports = [
    ./btop.nix
    ./firefox.nix
    ./git.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    unzip
  ];
}
