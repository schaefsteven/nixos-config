{ config, pkgs, ... } :

{
  imports = [
    ./btop.nix
    ./git.nix
    ./zsh.nix
  ];
}
