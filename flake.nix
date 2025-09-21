{
  description = "My NixOS + Home Manager setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {
    # Surface Pro configuration
    nixosConfigurations.sasfifsos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/sasfifsos/default.nix

        # Surface Pro hardware modules
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        nixos-hardware.nixosModules.microsoft-surface-common

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.stego = import ./home/stego/default.nix;
        }
      ];
    };

    # Desktop configuration
    nixosConfigurations.powertop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/powertop/default.nix

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.stego = import ./home/stego/default.nix;
        }
      ];
    };
    
    # Allow formatting with `nix fmt`
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
  };
}
