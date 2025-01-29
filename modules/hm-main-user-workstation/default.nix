{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    # terminal apps
    pandoc
    texliveTeTeX
    ventoy-full

    # desktop apps
    blender
    libreoffice
    orca-slicer
    zoom-us
  ];
}
