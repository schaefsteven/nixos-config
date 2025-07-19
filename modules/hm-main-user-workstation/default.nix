{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    # terminal apps
    pandoc
    texliveTeTeX
    # ventoy-full # designated insecure because of binary blobs

    # desktop apps
    blender-hip
    libreoffice
    obs-studio
    orca-slicer
    zoom-us
  ];
  services.dunst.enable = true;
}
