{
  description = "Personal Home Manager Inputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    hmConfig = { pkgs, ... }: {
      inherit pkgs;
      modules = [
        ./home.nix
      ];
    };
  };
}
