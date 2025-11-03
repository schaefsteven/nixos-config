{ config, pkgs, inputs, lib, ... }:

{
  networking.hostName = "brahe";

  # services.timesyncd.enable = false;

  system.stateVersion = "24.05"; # Should not change after install

  # networking.wireless.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # home-manager.users = { "usr" = import ./home.nix; };

  imports =
    [ ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ../../modules/nixos-core
      ../../modules/teamviewer.nix
      ./i3.nix
    ];

  home-manager.sharedModules = [ {
      home.packages = with pkgs; [
        qdirstat
        neovim
        brightnessctl # screen backlight brightness control
        nitrogen
      ];
    }
  ];

  home-manager.users.usr = {
    home.stateVersion = "24.05"; # Should not change after install

    imports = [
      ../../modules/hm-main-user-core
      ../../modules/hm-main-user-dev
      ../../modules/hm-main-user-workstation
      ../../modules/hm-main-user-dev
      ../../modules/rofi.nix
    ];

    home.packages = with pkgs; [
      framework-tool
    ];

    programs.alacritty.settings.font.size = lib.mkForce 8;

  };

  services.cloudflare-warp.enable = true;

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    displayManager = {
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --mode '2256x1504' --dpi 120 --scale 1 --primary
      '';
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/usr/.config/sops/age/keys.txt";
    secrets = {
      "smb_credentials" = {};
    };
  };
  
  # color schemes themes
  stylix = { 
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../assets/black.jpg;
    # imageScalingMode = "center"; # This currently only is supported by sway
  };

  # NAS mount
  fileSystems."/mnt/n" = {
    device = "//192.168.1.2/steven";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "cred=/run/secrets/smb_credentials"
      "uid=${toString config.users.users.usr.uid}"
      "gid=${toString config.users.groups.users.gid}"
    ];
  };

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 20;
    grub = {
      # To re-generate Windows grub entry, disable the extraEntries and enable useOSProber, 
      # then copy the windows menu entry from /boot/grub/grub.cfg into extraEntries.
      useOSProber = false;
      extraEntries = ''
        menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-AC63-F291' {
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root AC63-F291
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        '';
      enable = true;
      efiSupport = true;
      device = "nodev";
      gfxmodeEfi = "2560x1440";
      fontSize = 48;
      timeoutStyle = "menu";
    };
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
