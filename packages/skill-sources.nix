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

  duckdb-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "duckdb-skills";
    version = "0-unstable-2026-04-14";

    src = pkgs.fetchFromGitHub {
      owner = "duckdb";
      repo = "duckdb-skills";
      rev = "7feda8e01e22bc0886c86123f3884947e36d8c69";
      hash = "sha256-OmsODyirf2MzmoDMRx+c8xbkJWq2qOlMhXjKDV7PUv4=";
    };

    installPhase = installWithoutReadmes;
  };

  aws-agent-toolkit-for-aws = pkgs.stdenvNoCC.mkDerivation {
    pname = "aws-agent-toolkit-for-aws";
    version = "0-unstable-2026-07-20";

    src = pkgs.fetchFromGitHub {
      owner = "aws";
      repo = "agent-toolkit-for-aws";
      rev = "557631b655c961637cfc3d4e19a69bbc11495621";
      hash = "sha256-178oPQYHMJXFS/O+BDtiyP2XIKwmp+Ofz0tM9BUfWDM=";
    };

    installPhase = installWithoutReadmes;
  };

  pydantic-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "pydantic-skills";
    version = "0-unstable-2026-07-20";

    src = pkgs.fetchFromGitHub {
      owner = "pydantic";
      repo = "skills";
      rev = "ec86ff6b8e978b7461a4cb195241cf9fa4fe5e9c";
      hash = "sha256-05/pkkf2KxXvCmoYANNr3nZyS1un4Ex3qRG8xTLRpQs=";
    };

    installPhase = installWithoutReadmes;
  };
}
