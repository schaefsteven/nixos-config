{ config, pkgs, lib, ... }:

let
  # set which config files and what order here.
  i3ConfigFiles = [
    ../../configs/i3config
    ../../configs/i3-brahe
  ];
in {

  # import the global config
  imports = [ ../../modules/i3.nix ];
  # concat and apply the config file
  services.xserver.windowManager.i3.configFile = pkgs.writeText "i3config" (lib.concatStringsSep "\n" (map (f: builtins.readFile f) i3ConfigFiles));
}
