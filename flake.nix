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

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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

    paseo = {
      url = "github:getpaseo/paseo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    stylix,
    noctalia,
    nix-ai-tools,
    mytools,
    paseo,
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
      skillSources = import ./packages/skill-sources.nix {inherit pkgs;};
      dbxcli = pkgs.callPackage ./packages/dbxcli.nix {};
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
      packages.${system} = nvimPackages // skillSources // {inherit dbxcli;};
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
        configName = username;
      };
      wsl = rec {
        system = "x86_64-linux";
        username = "mebaran";
        homeDirectory = "/home/${username}";
        modules = cliModules;
        configName = "${username}@wsl";
      };
      mac = rec {
        system = "aarch64-darwin";
        username = "markbaran";
        homeDirectory = "/Users/${username}";
        modules = cliModules;
        configName = username;
      };
      work-linux = rec {
        system = "x86_64-linux";
        username = "mbaran";
        homeDirectory = "/home/${username}";
        modules = cliModules;
        configName = username;
      };
    };
    homeArgs = {
      pkgs,
      system,
      username,
      homeDirectory,
    }: {
      inherit system username homeDirectory;
      skillSources = import ./packages/skill-sources.nix {inherit pkgs;};
      aitools = nix-ai-tools.packages.${system};
      mytools = mytools.packages.${system};
      paseo = paseo.packages.${system};
      noctaliaPackage = noctalia.packages.${system}.default;
    };
    # NixOS module: manage this home config as part of `nh os switch`.
    nixosHome = {
      username,
      modules,
    }: {pkgs, ...}: {
      imports = [home-manager.nixosModules.home-manager];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-bak";
        extraSpecialArgs = homeArgs {
          inherit pkgs username;
          system = pkgs.stdenv.hostPlatform.system;
          homeDirectory = "/home/${username}";
        };
        users.${username} = {
          imports = modules;
          # stylix overlays set HM nixpkgs options, which useGlobalPkgs forbids.
          stylix.overlays.enable = false;
          # Rebuild the whole system against the local, unpushed home checkout.
          programs.zsh.shellAliases.nhs = "nh os switch ~/nix/mynixsys -- --override-input mynixhome ~/nix/mynixhome";
        };
      };
    };
    homeMaker = {
      system,
      username,
      homeDirectory,
      modules,
      configName,
    }: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages.${system}.default = home-manager.packages.${system}.default;
      formatter.${system} = pkgs.alejandra;
      homeConfigurations.${configName} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        extraSpecialArgs = homeArgs {inherit pkgs system username homeDirectory;};
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
    lib.foldl lib.recursiveUpdate {
      nixosModules.desktop = nixosHome {
        username = "mebaran";
        modules = desktopModules;
      };
    } (lib.attrValues (homeConfigs // nvimConfigs));
}
