{ config, pkgs, lib, inputs, ... }:

{
  networking.hostName = "naron";

  system.stateVersion = "24.05"; # Should not change after install

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  imports =
    [ ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ../../modules/nixos-core
      ../../modules/i3.nix
    ];

  services.xserver.windowManager.i3.configFile = lib.mkForce ../../configs/i3/htpc;
  # evdev:input:b0003v1915p1028* # i25 Rii mini
  # KEYBOARD_KEY_10082=f24 # power key
  services.udev.extraHwdb = ''
evdev:input:b0003v1915p1028*
 KEYBOARD_KEY_10082=f24
  '';

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../../derivations/big-launcher/big-launcher.nix {})
  ];

  home-manager.sharedModules = [ {
      home.packages = with pkgs; [
        qdirstat
        neovim
      ];
    }
  ];

  home-manager.users.usr = {
    home.stateVersion = "24.05"; # Should not change after install

    imports = [
      ../../modules/hm-main-user-core
    ];

    home.packages = with pkgs; [
      alacritty
  
      # terminal apps
      bashmount
      cowsay
      dig
      fastfetch
      inxi
      lolcat
      pandoc
      python3
      python312Packages.pip
      sops
      texliveTeTeX
      thefuck
      tree
      xclip
  
      # desktop apps
      google-chrome
      ungoogled-chromium
  
      # desktop utilities
      pavucontrol
    ];

    home.file.".config/bashmount/config" = {
      text = ''
        show_internal='0'
      '';
    };

  };

  services.openssh.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/usr/.config/sops/age/keys.txt";
    secrets = {
      "smb_credentials" = {};
    };
  };
  
  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # wireplumber.enable = true;
  };

}
