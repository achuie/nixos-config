{
  description = "My first nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:achuie/dotfiles";
      flake = false;
    };
    achuie-nvim = {
      url = "github:achuie/config.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }:
    let
      forAllSystems = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
          f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: import ./shell.nix { inherit pkgs; });
      nixosConfigurations = {
        nixtest = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs outputs; };
          modules = [ ./nixos/nixtest/configuration.nix ];
        };
        svalbard = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs outputs; };
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            nixos-hardware.nixosModules.common-gpu-amd
            ./nixos/svalbard/configuration.nix
          ];
        };
        buoy = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs; };
          modules = [
            ./nixos/buoy/configuration.nix
          ];
        };
      };
      homeConfigurations =
        let
          system = "x86_64-linux";
          firacode-dv = nixpkgs.legacyPackages.${system}.stdenvNoCC.mkDerivation {
            pname = "firacode-custom";
            version = "achuie";
            src = self.inputs.dotfiles;
            buildPhase = "";
            installPhase = ''
              output=$out/share/fonts/truetype
              mkdir -p $output
              cp ./nix-flakes/firacode/Fira\ Code\ Custom/* $output
            '';
            meta = {};
          };
          iosevka-dv = nixpkgs.legacyPackages.${system}.stdenvNoCC.mkDerivation {
            pname = "iosevka-custom";
            version = "achuie";
            src = self.inputs.dotfiles;
            buildPhase = "";
            installPhase = ''
              output=$out/share/fonts/truetype
              mkdir -p $output
              cp ./nix-flakes/iosevka/Iosevkacustom/* $output
            '';
            meta = {};
          };
        in
        {
          "achuie@nixtest" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = {
              inherit (self) inputs outputs;
              firacode = self.inputs.firacode.packages.${system}.default;
              iosevka = self.inputs.iosevka.packages.${system}.default;
            };
            modules = [ ./home-manager/achuie/home.nix ];
          };
          "achuie@svalbard" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = {
              inherit (self) inputs outputs;
              firacode = firacode-dv;
              iosevka = iosevka-dv;
            };
            modules = [ ./home-manager/achuie/svalbard.nix ];
          };
          "achuie@arch" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            extraSpecialArgs = {
              isOtherOS = true;
              inherit (self) inputs outputs;
              firacode = firacode-dv;
              iosevka = iosevka-dv;
            };
            modules = [ ./home-manager/achuie/arch.nix ];
          };
        };
    };
}
