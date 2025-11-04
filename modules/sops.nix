{ config, pkgs, lib, ... }:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/usr/.config/sops/age/keys.txt";
    secrets = {
      "smb_credentials" = {};
    };
  };
}
