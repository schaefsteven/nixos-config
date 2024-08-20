{ config, pkgs, ... }:

{
  # default main user
  users.users.usr = {
    isNormalUser = true;
    uid = 1000;
    description = "usr";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.groups.users = {
    members = [ "usr" ];
    gid = 100;
  };

  home-manager.users.usr = {
    home.username = "usr";
    home.homeDirectory = "/home/usr";
    programs.home-manager.enable = true;
  };
}
