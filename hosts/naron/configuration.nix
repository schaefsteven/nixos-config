{ config, pkgs, lib, inputs, self, ... }:

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

  services.displayManager.autoLogin = {
    enable = true;
    user = "usr";
  };

  services.xserver = {
    windowManager.i3.configFile = lib.mkForce null;
    displayManager = {
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output "HDMI-2" --mode "1920x1080"
      '';
    };
  };

  # xmodmap
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xmodmap}/bin/xmodmap "${pkgs.writeText  "xkb-layout" ''
        keycode 135 = ISO_Level5_Shift
    ''}"
  '';

  # unified remote server
  services.urserver.enable = true;

  # disable power putton on remote
  # evdev:input:b0003v1915p1028* # i25 Rii mini
  # KEYBOARD_KEY_10082=f24 # power key
  services.udev.extraHwdb = ''
evdev:input:b0003v1915p1028*
 KEYBOARD_KEY_10082=f24
  '';

  environment.systemPackages = with pkgs; [
    self.packages.${pkgs.system}.big-launcher
  ];

  environment.variables = {
    HASS_SERVER = "http://192.168.1.2:20810";
  };

  programs.bash.shellInit = ''
    export HASS_TOKEN="$(cat ${config.sops.secrets.hass_token.path})"
  '';

  home-manager.sharedModules = [ {
      home.packages = with pkgs; [
	home-assistant-cli
	playerctl
        neovim
        qdirstat
      ];
      stylix.targets = {
        dunst.enable = false;
      };
    }
  ];

  home-manager.users.usr = {
    home.stateVersion = "24.05"; # Should not change after install

    imports = [
      ../../modules/hm-main-user-core
      ../../modules/rofi.nix
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

    services.playerctld.enable = true;

    services.picom = {
      enable = true;
      vSync = true;
    };

    services.dunst = {
      enable = true;
      settings = {
        global = {
	  width = 999999;
	  offset = "0x0";
	  progress_bar_frame_width = 1;
	  progress_bar_min_width = 1920;
	  progress_bar_max_width = 1920;
	  progress_bar_height = 30;
	  frame_width = 0;
	  format = "%s %p";
	  highlight = "#FFFFFF99";
	  background = "#00000010";
        };
      };
    };

  };

  services.openssh.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/usr/.config/sops/age/keys.txt";
    secrets = {
      "hass_token" = {
        owner = config.users.users.usr.name;
        group = config.users.users.usr.group;
      };
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

  # color schemes themes
  stylix = { 
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../assets/black.jpg;
  };


}
