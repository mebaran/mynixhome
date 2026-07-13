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
    version = "0-unstable-2026-07-13";

    src = pkgs.fetchFromGitHub {
      owner = "aws";
      repo = "agent-toolkit-for-aws";
      rev = "7395888c2b6a06a66c967c5c83f339524d3d5d80";
      hash = "sha256-tMhJEim6t18ZFGcJLk8iY5yQ0PJXy+8Mom4MnHEn7IM=";
    };

    installPhase = installWithoutReadmes;
  };

  pydantic-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "pydantic-skills";
    version = "0-unstable-2026-07-10";

    src = pkgs.fetchFromGitHub {
      owner = "pydantic";
      repo = "skills";
      rev = "6730ba856ab097042e8e704cf4faba3cfb9bf672";
      hash = "sha256-1y2nNgHbV3RH12h0/jodHI6UpGtnXxyshCiDg4+u9Nw=";
    };

    installPhase = installWithoutReadmes;
  };
}
