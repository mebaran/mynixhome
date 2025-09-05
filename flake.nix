{
  description = "MEB Home Manager";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mynixvim = {
      url = "github:mebaran/mynixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.mynixoverlays.follows = "mynixoverlays";
    };
    mynixoverlays = {
      url = "github:mebaran/mynixoverlays";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    mynixvim,
    mynixoverlays,
    ...
  }: let
    lib = nixpkgs.lib;
    homes = {
      personal-linux = rec {
        system = "x86_64-linux";
        username = "mebaran";
        homeDirectory = "/home/${username}";
      };
      mac = rec {
        system = "aarch64-darwin";
        username = "markbaran";
        homeDirectory = "/Users/${username}";
      };
      work-linux = rec {
        system = "x86_64-linux";
        username = "mbaran";
        homeDirectory = "/home/${username}";
      };
    };
    homeMaker = {
      system,
      username,
      homeDirectory,
    }: let pkgs = import nixpkgs {
      inherit system;
      overlays = [ mynixoverlays.overlays.default ];
    };
    in {
      packages.${system}.default = home-manager.packages.${system}.default;
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
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
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ mynixvim.packages.${system}.nixlang ];
      };
    };
    homeConfigs = lib.mapAttrs (k: v: homeMaker v) homes;
  in
    lib.foldl lib.recursiveUpdate {} (lib.attrValues homeConfigs); 
}
