{ config, pkgs, lib, ... }:

let
  # set which config files and what order here.
  i3ConfigFiles = [
    ../../configs/i3/core
    ../../configs/i3/workspaces
    ../../configs/i3/default-appearance
    ../../configs/i3/applications
    ./i3-host-config
  ];
in {

  # import the global config for xserver etc
  imports = [ ../../modules/i3.nix ];
  # concat and apply the config file
  services.xserver.windowManager.i3.configFile = pkgs.writeText "i3config" (lib.concatStringsSep "\n" (map (f: builtins.readFile f) i3ConfigFiles));
}
