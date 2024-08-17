{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi-calc
    rofi-power-menu
    rofimoji
  ];

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofimoji pkgs.rofi-calc ];
    extraConfig = {
      m = "primary";
      combi-modi = "drun,emoji:rofimoji";
      combi-display-format = "{mode}: {text}";
      scroll-method = 1;
      font = "mono 20";
      modi = "combi,calc,emoji:rofimoji,power:rofi-power-menu";
      display-combi = "🚀: ";
      display-calc = "🧮: ";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "#entry" = {
        placeholder = "beep boop...";
	placeholder-color = mkLiteral "rgba(255,255,255,0.1)";
      };
      "#window" = {
        padding = mkLiteral "0.3em";
      };
    };
  };

  home.file.".config/rofimoji.rc" = {
    text = ''
      action = copy
      max-recent = 0
    '';
  };
}
