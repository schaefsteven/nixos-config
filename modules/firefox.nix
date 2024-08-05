{ config, pkgs, ... }:

  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "de" "en-US" ];

    /* ---- POLICIES ---- */
    # Check about:policies#documentation for options.
    policies = {
      DisablePocket = true;
	OfferToSaveLogins = false;
	OverrideFirstRunPage = "";
	OverridePostUpdatePage = "";
	Homepage = { URL = "https://yooper.cc"; StartPage = "homepage"; };
	NewTabPage = false;
	PromptForDownloadLocation = true;

      /* ---- EXTENSIONS ---- */
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # ublock origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
	    default_area = "menupanel";
        };
	  # bitwarden
	  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
	    install_url =  "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
	    installation_mode = "normal_installed";
	    default_area = "navbar";
	  };
	  # darkreader
	  "addon@darkreader.org" = {
	    install_url =  "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
	    installation_mode = "normal_installed";
	    default_area = "navbar";
	  };
	  # vimium-c
	  "vimium-c@gdh1995.cn" = {
	    install_url =  "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
	    installation_mode = "normal_installed";
	    default_area = "menubar";
	  };
	  # auto-fullscreen
	  "{809d8a54-1e2d-4fbb-81b4-36ff597b225f}" = {
	    install_url =  "https://addons.mozilla.org/firefox/downloads/latest/i-auto-fullscreen/latest.xpi";
	    installation_mode = "normal_installed";
	    default_area = "menubar";
	  };
      };

      /* ---- PREFERENCES ---- */
      # Check about:config for options.
      Preferences = { 
	  "browser.sessionstore.resume_from_crash" = false; # don't auto-restore after a crash
        "extensions.pocket.enabled" = lock-false; # Disables Pocket
	  "browser.theme.content-theme" = 0; # Dark Mode
	  "browser.theme.toolbar-theme" = 0; # Dark Mode
	  "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true; # Enable userChrome.css
	  # "signon.rememberSignons" = lock-false; # Autofill
      };
    };
  };
}
