{ config, pkgs, ... } :

{
  imports = [
    ./btop.nix
    ./firefox.nix
    ./git.nix
    ./zsh.nix
  ];
}
