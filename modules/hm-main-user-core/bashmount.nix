{ config, pkgs, ... } :

{
  home.packages = with pkgs; [
    bashmount
  ];

  home.file.".config/bashmount/config" = {
    text = ''
      show_internal='0'
    '';
  };
}
