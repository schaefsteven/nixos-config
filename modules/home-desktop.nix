{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
    ./rofi.nix
  ];
}
