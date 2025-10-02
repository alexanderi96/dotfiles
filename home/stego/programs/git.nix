{ config, pkgs, ... }:
{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "Alessandro Ianne";
    userEmail = "alessandro.ianne96@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
