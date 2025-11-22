{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Containerization packages
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    distrobox
  ];

  # Docker daemon configuration
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Open firewall ports for Docker
  networking.firewall.allowedTCPPorts = [
    2376 # Docker daemon TLS
    2375 # Docker daemon (unsecured)
  ];

  networking.firewall.allowedUDPPorts = [
    2376 # Docker daemon TLS
  ];

  # Docker group configuration
  users.groups.docker = {};
}
