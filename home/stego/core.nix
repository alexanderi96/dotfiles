{ config, pkgs, ... }: {
  imports = [
    ./programs/git.nix
    ./programs/shell.nix
    ./programs/direnv.nix
  ];

  home.packages = with pkgs; [
    opencode
    keychain  # usato da shell.nix per l'agent ssh
  ];

  # Dotfiles non migrabili a moduli HM: restano symlink dichiarativi
  xdg.configFile = {
    "scripts" = { source = ./dotfiles/config/scripts; recursive = true; };
    "nvim/init.vim".source = ./dotfiles/config/nvim/init.vim;
    "opencode" = { source = ./dotfiles/config/opencode; recursive = true; };
  };

  home.file.".vimrc".source = ./dotfiles/vimrc;
}
