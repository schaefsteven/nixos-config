{ config, pkgs, ... }:

{
  home-manager.users.usr = {
    programs.git = {
      enable = true;
      userName = "schaefsteven";
      userEmail = "66270901+schaefsteven@users.noreply.github.com";
      extraConfig = { 
        init.defaultBranch = "main";
        credential.helper = "git-credential-netrc";
      };
    };
  };
}
