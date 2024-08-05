# todo
# alacritty config
# uBlacklist nixos

# ideas
# boot.plymouth.enable?
# replace monitor names in i3config?


{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
      ../../modules/firefox.nix
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/usr/.config/sops/age/keys.txt";
    secrets = {
      "smb_credentials" = {};
    };
  };

  programs.ssh.extraConfig = ''
    Host git
      User git
      IdentityFile /home/usr/.ssh/id_rsa
  '';

  environment.systemPackages = with pkgs; [
    neovim
    alacritty
    python3
    python312Packages.pip
    thefuck
    nerdfonts

    # DE stuff
    i3
    base16-schemes

    # for mount.cifs, required unless domain name resolution is not needed
    cifs-utils
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # boot.initrd.kernelModules = [ "amdgpu" ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  users.defaultUserShell = pkgs.zsh;
  
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lhog --group-directories-first";
      la = "ls -alhog --group-directories-first";
      nivm = "nvim";
      py = "python3";
      gaac = "git add . && git commit";
      nrs = "sudo nixos-rebuild switch --flake ~/.nix";
      xclip = "xclip -selection clipboard";
      nixgit = "git -C ~/.nix";
    };
    ohMyZsh = {
      enable = true;
      theme = "gozilla";
      plugins = ["git" "thefuck"];
    };
    shellInit = "fastfetch";
  };

  # color schemes themes
  stylix = { 
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../background-image;
    # imageScalingMode = "center"; # This currently only is supported by sway
  };


  # i3
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''Option "TearFree" "true"'';

    # Keyboard layout and mapping
    xkb = {
      options = builtins.concatStringsSep "," [
        "ctrl:nocaps" # use Capslock as Ctrl
        "shift:both_capslock" # double-shift for capslock
        "altwin:swap_alt_win" # swap lwin and lalt
      ];
      layout = "us";
      variant = "";
    };

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
      # lightdm.background = "#000000"; # overridden by stylix
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
      '';
    };
  
    windowManager.i3 = {
      enable = true;
      configFile = ../../configs/i3config;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

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
    # options = let
      # automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      # in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${toString config.users.users.usr.uid},gid=${toString config.users.groups.users.gid}"];
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.usr = {
    isNormalUser = true;
    uid = 1000;
    description = "usr";
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [];
  };

  users.groups.users = {
    members = [ "usr" ];
    gid = 100;
  };

  security.sudo.extraConfig = ''
    # sudo auth applies to all terminals
    Defaults !tty_tickets
    # 60 minutes before having to re-auth
    Defaults timestamp_timeout = 60
  '';

  home-manager = {
    useGlobalPkgs = true; # Originally set to allow unfree packages to be installed by home-manager
    extraSpecialArgs = { inherit inputs; };
    users = {
      "usr" = import ../../home.nix;
    };
    backupFileExtension = "backup";
  };

  # Stuff from default configuration.nix:

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 20;
    grub = {
      # To re-generate Windows grub entry, disable the extraEntries and enable useOSProber, 
      # then copy the windows menu entry from /boot/grub/grub.cfg into extraEntries.
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

  networking.hostName = "arion"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
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

  # Configure keymap in X11
  services.xserver = {
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
