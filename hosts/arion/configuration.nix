{ config, pkgs, inputs, self, ... }:

{
  networking.hostName = "arion";

  system.stateVersion = "23.11"; # Should not change after install

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  imports =
    [ ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ../../modules/nas-mounts.nix
      ../../modules/nixos-core
      ../../modules/nixos-gaming
      ../../modules/sops.nix
      ../../modules/stylix.nix
      ../../modules/teamviewer.nix
      ./i3.nix
    ];

  # host-specific services
  services.openssh.enable = true;

  # unified remote server
  services.urserver.enable = true;

  # mouse cursor pointer speed for vertical mouse
  services.libinput.mouse.accelSpeed = "-1";

  networking.firewall.allowedTCPPorts = [ 
    8668 # Verge3D
  ];

  # big-launcher (for testing)
  environment.systemPackages = with pkgs; [
    self.packages.${pkgs.system}.big-launcher
  ];

  home-manager.sharedModules = [ {
      home.packages = with pkgs; [
        qdirstat
        neovim
        nitrogen
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
      ./cuemix-desktop-entry.nix
    ];
  };


  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    displayManager = {
      setupCommands = ''
        LEFT='HDMI-A-1'
        CENTER='DisplayPort-0'
        RIGHT='HDMI-A-0'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --mode '3840x2160' --dpi 120 --scale 1 --primary
        ${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --rotate right --scale 1.25 --left-of $CENTER
        ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --scale 1.25 --right-of $CENTER
        ${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --pos 0x0
        ${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --pos 1350x0
        ${pkgs.xorg.xrandr}/bin/xrandr --output $RIGHT --pos 5190x0
	${pkgs.nitrogen}/bin/nitrogen --restore
      '';
    };
  };

  # game drive
  boot.supportedFilesystems = ["ntfs"];
  fileSystems."/mnt/g" = {
    device = "/dev/disk/by-uuid/6692F0CE92F0A3A9";
    fsType = "ntfs";
    options = [
      "uid=${toString config.users.users.usr.uid}"
      "gid=${toString config.users.groups.users.gid}"
    ];
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
        menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-94DD-ADB6' {
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root 94DD-ADB6
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
