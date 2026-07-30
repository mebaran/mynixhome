{pkgs}: let
  installWithoutReadmes = ''
    runHook preInstall
    cp -R . "$out"
    find "$out" -type f \( -iname README -o -iname 'README.*' \) -delete
    runHook postInstall
  '';
in {
  openai-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "openai-skills";
    version = "0-unstable-2026-06-24";

    src = pkgs.fetchFromGitHub {
      owner = "openai";
      repo = "skills";
      rev = "49f948faa9258a0c61caceaf225e179651397431";
      hash = "sha256-t4oGnFg0YpxJaQiFpgTiwYhaFoZK6wPDiqvHoG0bXiU=";
    };

    installPhase = installWithoutReadmes;
  };
}
