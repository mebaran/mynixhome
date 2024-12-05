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
  } @ inputs: let
    langs = {
      nixlang = import ./lang/nixlang.nix;
      python = import ./lang/python.nix;
      web = import ./lang/web.nix;
    };
    devTools = {pkgs, ...}: with pkgs; [
      aider-chat
      fd
      git
      lazygit
      ripgrep
    ];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        inherit langs devTools;  
      };

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
        };

        nvim = nixvim'.makeNixvimWithModule nixvimModule;

      in rec {
        packages =
          {
            default = nvim;
          }
          // builtins.mapAttrs (name: value: nvim.extend value) langs;

        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        devShells = with pkgs;
          builtins.mapAttrs
          (a: v: mkShell {buildInputs = (devTools pkgs) ++ [v];})
          packages;
      };
    };
}
