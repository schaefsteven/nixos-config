{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "schaefsteven";
    userEmail = "66270901+schaefsteven@users.noreply.github.com";
    extraConfig = { 
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  home.packages = with pkgs; [
    git-lfs
    ];
}
