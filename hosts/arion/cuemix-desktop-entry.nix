{ pkgs, ... }:

let
  cuemixDesktopItem = pkgs.makeDesktopItem {
    name = "cuemix5";
    desktopName = "Motu CueMix 5";
    exec = "electron /home/usr/.config/motu/com.motu.CueMix5-1.0.0/resources/app.asar";
  };
in {
  home.packages = [ cuemixDesktopItem ];
}
