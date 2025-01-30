{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./main-user-core.nix
    ./udisks2.nix
    ./flatpak.nix
  ];

  # core system packages
  environment.systemPackages = with pkgs; [
    base16-schemes # for use with stylix
    cifs-utils # for mounting NAS, etc
    usbutils # lsusb
    pulseaudio
    xdotool

    # tools for identifying keycodes and keysyms
    evtest
    xorg.xev

  ];

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gtk2";
  };

  # fonts
  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # core environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # git use ssh key
  programs.ssh.extraConfig = ''
    Host git
      User git
      IdentityFile /home/usr/.ssh/id_rsa
  '';

  # set default shell to zsh
  programs.zsh.enable = true; # zsh is configured in home-manager, but this has to be here for defaultUserShell to work
  users.defaultUserShell = pkgs.zsh;

  # sudo conviniences
  security.sudo.extraConfig = ''
    # sudo auth applies to all terminals
    Defaults !tty_tickets
    # 60 minutes before having to re-auth
    Defaults timestamp_timeout = 60
  '';

  # home-manager core config
  home-manager = {
    useGlobalPkgs = true; # allow unfree packages to be installed by home-manager
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
  };

  networking.networkmanager.enable = true;

  services.printing.enable = true;

  time.timeZone = "US/Eastern";

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

}
