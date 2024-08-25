{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  # hostnames pool: https://en.wikipedia.org/wiki/List_of_proper_names_of_exoplanets
  {
    nixosConfigurations.arion = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/arion/configuration.nix
	inputs.home-manager.nixosModules.default
	inputs.stylix.nixosModules.stylix
      ];
    };
    nixosConfigurations.naron = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/naron/configuration.nix
	inputs.home-manager.nixosModules.default
	# inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
