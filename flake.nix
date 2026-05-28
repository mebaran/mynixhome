{
  description = "MEB Home Manager";

  nixConfig = {
    extra-substituters = ["https://numtide.cachix.org"];
    extra-trusted-public-keys = ["numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];
  };

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

    nix-ai-tools = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mytools = {
      url = "github:mebaran/mytools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    stylix,
    nix-ai-tools,
    mytools,
    ...
  }: let
    lib = nixpkgs.lib;
    nvimSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    nvimLangs = {
      nixlang = import ./nixvim/lang/nixlang.nix;
      python = import ./nixvim/lang/python.nix;
      web = import ./nixvim/lang/web.nix;
      sql = import ./nixvim/lang/sql.nix;
      golang = import ./nixvim/lang/golang.nix;
      json = import ./nixvim/lang/json.nix;
      markdown = import ./nixvim/lang/markdown.nix;
    };
    nvimOutputsFor = system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      nixvimLib = nixvim.lib.${system};
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        inherit pkgs;
        module = import ./nixvim/config;
        extraSpecialArgs = {
          aitools = nix-ai-tools.packages.${system};
        };
      };
      baseNvim = nixvim'.makeNixvimWithModule nixvimModule;
      allLangNvim = lib.foldl (n: l: n.extend l) baseNvim (lib.attrValues nvimLangs);
      nvimPackages =
        {
          nvim = allLangNvim;
          nvim-all = allLangNvim;
        }
        // lib.mapAttrs' (name: value:
          lib.nameValuePair "nvim-${name}" (baseNvim.extend value))
        nvimLangs;
    in {
      packages.${system} = nvimPackages;
      checks.${system}.nvim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      devShells.${system} = lib.mapAttrs' (name: value:
        lib.nameValuePair name (pkgs.mkShell {buildInputs = [value];}))
      nvimPackages;
    };
    cliModules = [
      stylix.homeModules.stylix
      nixvim.homeModules.nixvim
      ./home.nix
    ];
    desktopModules =
      cliModules
      ++ [
        ./desktop
      ];
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
      formatter.${system} = pkgs.alejandra;
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = {
          inherit system username homeDirectory;
          aitools = nix-ai-tools.packages.${system};
          mytools = mytools.packages.${system};
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          self.packages.${system}.nvim-nixlang
          pkgs.alejandra
        ];
      };
    };
    homeConfigs = lib.mapAttrs (k: v: homeMaker v) homes;
    nvimConfigs = lib.genAttrs nvimSystems nvimOutputsFor;
  in
    lib.foldl lib.recursiveUpdate {} (lib.attrValues (homeConfigs // nvimConfigs));
}
