{
  description = "MEB Home Manager";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
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
    niri,
    stylix,
    ...
  }: let
    cliModules = [
      stylix.homeModules.stylix
      ./home.nix
    ];
    desktopModules =
      cliModules
      ++ [
        niri.homeModules.niri
        niri.homeModules.stylix
        ./desktop
      ];
    lib = nixpkgs.lib;
    homes = {
      personal-linux = rec {
        system = "x86_64-linux";
        username = "mebaran";
        homeDirectory = "/home/${username}";
        modules = desktopModules;
      };
      mac = rec {
        system = "aarch64-darwin";
        username = "markbaran";
        homeDirectory = "/Users/${username}";
        modules = cliModules;
      };
      work-linux = rec {
        system = "x86_64-linux";
        username = "mbaran";
        homeDirectory = "/home/${username}";
        modules = cliModules;
      };
    };
    homeMaker = {
      system,
      username,
      homeDirectory,
      modules,
    }: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [mynixoverlays.overlays.default];
      };
    in {
      packages.${system}.default = home-manager.packages.${system}.default;
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit mynixvim system username homeDirectory;
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [mynixvim.packages.${system}.nixlang];
      };
    };
    homeConfigs = lib.mapAttrs (k: v: homeMaker v) homes;
  in
    lib.foldl lib.recursiveUpdate {} (lib.attrValues homeConfigs);
}
