{ config, pkgs, lib, ... }:

{
  services.ollama = {
    enable = true;
    loadModels = ["deepseek-r1:14b" "deepseek-coder:6.7b"];
    openFirewall = true;
    host = "0.0.0.0";
    package = pkgs.ollama-rocm;
  };
}
