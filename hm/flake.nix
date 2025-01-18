{
  description = "MEB Home Manager";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mynixvim = {
      url = "github:/mebaran/flakes?dir=nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    mynixvim,
    ...
  }: let
    lib = nixpkgs.lib;
    homes = {
      linux = rec {
        system = "x86_64-linux";
        username = "mebaran";
        homeDirectory = "/home/${username}";
      };
      mac = rec {
        system = "aarch64-darwin";
        username = "markbaran";
        homeDirectory = "/Users/${username}";
      };
    };
    homeMaker = {
      system,
      username,
      homeDirectory,
    }: {
      packages.${system}.default = home-manager.packages.${system}.default;
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit mynixvim system username homeDirectory;
        };
      };
    };
    homeConfigs = lib.concatMapAttrs (k: v: homeMaker v) homes;
    nixosConfig = lib.nixosSystem {
      modules = [ 
        ./configuration.nix
      ];
    };
  in
    homeConfigs // { nixosConfigurations.nixos = nixosConfig; };
}
