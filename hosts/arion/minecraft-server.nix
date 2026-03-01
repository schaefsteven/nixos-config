{ config, pkgs, lib, ... }:

{
  services.minecraft-server = {
    enable = true;
    openFirewall = true;
    package = pkgs.papermc;
    eula = true;
    };
}

# notes
# To be able to easily work with the server (at /var/lib/minecraft) after setup,
# sudo chmod g+s /var/lib/minecraft
