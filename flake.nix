{
  description = "My first nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      forAllSystems = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
          f (import nixpkgs { inherit system; }));
    in
    {
      devShells = forAllSystems (pkgs: import ./shell.nix { inherit pkgs; });
      nixosConfigurations = {
        nixtest = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs outputs; };
          modules = [ ./nixos/configuration.nix ];
        };
      };
      homeConfigurations = {
        "mujin@nixtest" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit (self) inputs outputs; };
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}
