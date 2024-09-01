{ config, pkgs, ... } :

{
  services.udisks2 = {
    enable = true;
  };

  home-manager.sharedModules = [ {
      services.udiskie = {
        enable = true;
	tray = "never"; # currently can't enable with i3 Unit tray.target not found
      };
    }
  ];

}
