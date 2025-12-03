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

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mynixvim = {
      url = "github:mebaran/mynixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mytools = {
      url = "github:mebaran/mytools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    mynixvim,
    stylix,
    niri,
    nix-ai-tools,
    mytools,
    ...
  }: let
    nixConfig = {
      extra-substituters = ["https://numtide.cachix.org"];
      extra-trusted-public-keys = ["numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];
    };
    cliModules = [
      stylix.homeModules.stylix
      ./home.nix
    ];
    desktopModules =
      cliModules
      ++ [
        # niri.homeModules.niri
        # niri.homeModules.stylix
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
      };
    in {
      packages.${system}.default = home-manager.packages.${system}.default;
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit mynixvim system username homeDirectory;
          aitools = nix-ai-tools.packages.${system};
          mytools = mytools.packages.${system};
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [mynixvim.packages.${system}.nixlang];
      };
    };
    homeConfigs = lib.mapAttrs (k: v: homeMaker v) homes;
  in
    {inherit nixConfig;} // (lib.foldl lib.recursiveUpdate {} (lib.attrValues homeConfigs));
}
