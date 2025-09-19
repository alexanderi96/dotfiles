{
  description = "My Surface Pro 5 flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.sasfifsos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./sasfifsos_configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
	nixos-hardware.nixosModules.microsoft-surface-common
      ];
    };
  };
}
