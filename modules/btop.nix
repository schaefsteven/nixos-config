{ config, pkgs, ... }:

{
  home-manager.users.usr = {
    programs.btop = {
      enable = true;
      settings = {
        # color_theme = "gruvbox_material_dark";
        theme_background = false;
        update_ms = 500;
        vim_keys = true;
      };
    };
  };
}
