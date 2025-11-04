{ config, pkgs, lib, ... }:

{
  # color schemes themes
  stylix = { 
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../assets/black.jpg;
    # imageScalingMode = "center"; # This currently only is supported by sway
  };
}
