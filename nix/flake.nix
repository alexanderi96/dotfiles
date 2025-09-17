{
  description = "My Surface Pro 5 flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.sasfifsos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./sasfifsos_configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.stego = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
