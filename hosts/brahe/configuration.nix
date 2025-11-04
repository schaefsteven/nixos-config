{ config, pkgs, inputs, lib, ... }:

{
  networking.hostName = "brahe";

  system.stateVersion = "24.05"; # Should not change after install

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  imports =
    [ ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ../../modules/nas-mounts.nix
      ../../modules/nixos-core
      ../../modules/sops.nix
      ../../modules/stylix.nix
      ../../modules/teamviewer.nix
      ./i3.nix
    ];

  # host-specific services
  services.cloudflare-warp.enable = true;

  home-manager.sharedModules = [ {
      home.packages = with pkgs; [
        neovim # I think I did this here so it would be available as sudo
        brightnessctl # screen backlight brightness control
      ];
    }
  ];

  home-manager.users.usr = {
    home.stateVersion = "24.05"; # Should not change after install

    imports = [
      ../../modules/hm-main-user-core
      ../../modules/hm-main-user-workstation
      ../../modules/hm-main-user-dev
      ../../modules/rofi.nix
    ];

    home.packages = with pkgs; [
      framework-tool
    ];

    programs.alacritty.settings.font.size = lib.mkForce 8;

  };

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    displayManager = {
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --mode '2256x1504' --dpi 120 --scale 1 --primary
      '';
    };
  };

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 20;
    grub = {
      # To re-generate Windows grub entry, disable the extraEntries and enable 
      # useOSProber, then copy the windows menu entry from /boot/grub/grub.cfg 
      # into extraEntries.
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

  # sound
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
