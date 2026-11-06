{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "schaefsteven";
        email = "66270901+schaefsteven@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  home.packages = with pkgs; [
    git-lfs
    ];
}
