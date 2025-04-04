{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    # terminal apps
    pandoc
    texliveTeTeX
    ventoy-full

    # desktop apps
    blender-hip
    libreoffice
    orca-slicer
    zoom-us
  ];
  services.dunst.enable = true;
}
