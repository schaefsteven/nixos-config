{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    # terminal apps
    ventoy-full
    texliveTeTeX
    pandoc

    # desktop apps
    zoom-us
    orca-slicer
  ];
}
