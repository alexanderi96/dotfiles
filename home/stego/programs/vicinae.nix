{ config, pkgs, vicinae, ... }:
{
  imports = [
    vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    settings = {
      # Optional configuration
      # Uncomment and modify as needed:
      # faviconService = "twenty"; # twenty | google | none
      # font.size = 11;
      # popToRootOnClose = false;
      # rootSearch.searchFiles = false;
      # theme.name = "vicinae-dark";
      # window = {
      #   csd = true;
      #   opacity = 0.95;
      #   rounding = 10;
      # };
    };
  };
}
