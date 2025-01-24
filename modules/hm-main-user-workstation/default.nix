{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    # terminal apps
    pandoc
    texliveTeTeX
    ventoy-full

    # desktop apps
    blender
    orca-slicer
    zoom-us
  ];
  services.dunst.enable = true;
}
