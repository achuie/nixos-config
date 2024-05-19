{
  description = "My first nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firacode = {
      url = "github:achuie/dotfiles?dir=nix-flakes/firacode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iosevka = {
      url = "github:achuie/dotfiles?dir=nix-flakes/iosevka";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }:
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
            nix-flatpak.nixosModules.nix-flatpak
            ./nixos/svalbard/configuration.nix
          ];
        };
      };
      homeConfigurations =
        let
          system = "x86_64-linux";
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
              firacode = self.inputs.firacode.packages.${system}.default;
              iosevka = self.inputs.iosevka.packages.${system}.default;
            };
            modules = [ ./home-manager/achuie/home.nix ];
          };
        };
    };
}
