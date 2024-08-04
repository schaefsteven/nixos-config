{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "usr";
  home.homeDirectory = "/home/usr";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fastfetch
    discord
    google-chrome
    ungoogled-chromium
    cowsay
    lolcat
    obsidian
    gpick
    zoom-us
    sops
    orca-slicer
    git-credential-manager
    dig
    rofimoji
    rofi-calc
    rofi-power-menu
    xclip

    pavucontrol
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.git = {
    enable = true;
    userName = "schaefsteven";
    userEmail = "66270901+schaefsteven@users.noreply.github.com";
    extraConfig = { 
      init.defaultBranch = "main";
      credential.helper = "git-credential-netrc";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      # color_theme = "gruvbox_material_dark";
      theme_background = false;
      update_ms = 500;
      vim_keys = true;
    };
  };

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofimoji pkgs.rofi-calc ];
    extraConfig = {
      m = "primary";
      combi-modi = "drun,emoji:rofimoji";
      combi-display-format = "{mode}: {text}";
      scroll-method = 1;
      font = "mono 20";
      modi = "combi,calc,emoji:rofimoji,power:rofi-power-menu";
      display-combi = "🚀: ";
      display-calc = "🧮: ";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "#entry" = {
        placeholder = "beep boop...";
	placeholder-color = mkLiteral "rgba(255,255,255,0.1)";
      };
      "#window" = {
        padding = mkLiteral "0.3em";
      };
    };
  };
  home.file.".config/rofimoji.rc" = {
    text = ''
      action = copy
      max-recent = 0
    '';
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/usr/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
