{ config, pkgs, ... }:
{
  # Shell configuration with custom bashrc
  # Note: We're using a custom bashrc file, so bash module is disabled
  # but we still want shell-related tools and aliases
  
  programs.bash = {
    enable = false;  # Custom bashrc is used instead
    # If you want to enable bash module and migrate your bashrc, set this to true
    # and move your custom configurations here
  };

  # Shell aliases that can be used if you enable bash module
  # Currently these are in your custom bashrc
  # programs.bash.shellAliases = {
  #   ll = "eza -la";
  #   la = "eza -la";
  #   ls = "eza";
  #   cat = "bat";
  #   grep = "rg";
  #   find = "fd";
  #   top = "btop";
  # };
}
