{
  description = "Base Nvim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        }; 
        
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
        
        devTools = with pkgs; [
          aider-chat
          fd
          git
          lazygit
          ripgrep
        ];

        packs = {
          nixlang = import ./lang/nixlang.nix;
          python = import ./lang/python.nix;
          web = import ./lang/web.nix;
        };
        
      in rec {
        packages =
          {
            default = nvim;
            _langs = packs;
          }
          // builtins.mapAttrs (name: value: nvim.extend value) packs;
        
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };


        devShells = with pkgs;
          builtins.mapAttrs
          (a: v: mkShell {buildInputs = devTools ++ [v];})
          packages;
      };
    };
}
