{
  description = "My NixOS + Home Manager setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {
    nixosConfigurations.sasfifsos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/sasfifsos/configuration.nix
        ./modules/common.nix
        ./modules/programs.nix
        ./modules/services.nix

        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        nixos-hardware.nixosModules.microsoft-surface-common

        # Attiva home-manager come modulo di NixOS
        home-manager.nixosModules.home-manager
        {
          home-manager.users.stego = import ./home/stego.nix;
        }
      ];
    };
    
     # Allow formatting with `nix fmt`
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

  };
}

