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

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
  {
    # Surface Pro configuration
    nixosConfigurations.sasfifsos = nixpkgs.lib.nixosSystem {
      system = system;
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
      system = system;
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

    # DevShell globale
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        # Rust
        pkgs.rustc
        pkgs.cargo
        pkgs.rustfmt
        pkgs.clippy
        pkgs.rust-analyzer

        # Go
        pkgs.go

        # Compilatori & tool
        pkgs.gcc
        pkgs.glibc
        pkgs.pkg-config
        pkgs.openssl
        pkgs.cmake

        # Librerie native
        pkgs.alsa-lib
        pkgs.eudev

        # Librerie grafiche per Bevy e sviluppo giochi
        pkgs.xorg.libX11
        pkgs.xorg.libXcursor
        pkgs.xorg.libXrandr
        pkgs.xorg.libXi
        pkgs.libxkbcommon
        pkgs.wayland
        pkgs.vulkan-loader
        pkgs.vulkan-headers
        pkgs.vulkan-tools
        pkgs.mesa
        pkgs.libGL
        pkgs.fontconfig
        pkgs.freetype
      ];

      shellHook = ''
        echo "💻 DevShell enabled with graphics support for Bevy development."
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
          pkgs.xorg.libX11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXrandr
          pkgs.xorg.libXi
          pkgs.libxkbcommon
          pkgs.wayland
          pkgs.vulkan-loader
          pkgs.mesa
          pkgs.libGL
          pkgs.alsa-lib
          pkgs.eudev
        ]}:$LD_LIBRARY_PATH"
      '';

      # Environment variables
      RUST_BACKTRACE=1;
    };
    
    # Allow formatting with `nix fmt`
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
  };
}
