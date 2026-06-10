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
    version = "0-unstable-2026-05-29";

    src = pkgs.fetchFromGitHub {
      owner = "openai";
      repo = "skills";
      rev = "a8924c2a35cfa290458852c4fad17c9133054c2e";
      hash = "sha256-drA/ypVE+yK4W2Bj8IUtWaVLF390Pfy7YLcmdju5dow=";
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
    version = "0-unstable-2026-06-09";

    src = pkgs.fetchFromGitHub {
      owner = "aws";
      repo = "agent-toolkit-for-aws";
      rev = "c0991f463b54ac94af32a730d6d13293dcff98cf";
      hash = "sha256-QiR07nlnajVu50hAeOizj5qhMkbOWKmD1bpkb1Y2c2c=";
    };

    installPhase = installWithoutReadmes;
  };

  pydantic-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "pydantic-skills";
    version = "0-unstable-2026-06-10";

    src = pkgs.fetchFromGitHub {
      owner = "pydantic";
      repo = "skills";
      rev = "1e7a4567d8375e8ef07ad078d7f38bc03ce5e944";
      hash = "sha256-PzuqYip+2lrJSgk2/e2x6Npe13r3txjLKzYIAOUHTpI=";
    };

    installPhase = installWithoutReadmes;
  };
}
