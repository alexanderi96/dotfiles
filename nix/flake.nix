{
  description = "My Surface Pro 5 flake!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # use the following for unstable:
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixosConfigurations = {
      sasfifsos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sasfifsos_configuration.nix ];
      };
    };
  };

}
