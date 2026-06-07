{pkgs}: {
  openai-skills = pkgs.stdenvNoCC.mkDerivation {
    pname = "openai-skills";
    version = "0-unstable-2026-05-29";

    src = pkgs.fetchFromGitHub {
      owner = "openai";
      repo = "skills";
      rev = "a8924c2a35cfa290458852c4fad17c9133054c2e";
      hash = "sha256-drA/ypVE+yK4W2Bj8IUtWaVLF390Pfy7YLcmdju5dow=";
    };

    installPhase = ''
      runHook preInstall
      cp -R . "$out"
      runHook postInstall
    '';
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

    installPhase = ''
      runHook preInstall
      cp -R . "$out"
      runHook postInstall
    '';
  };

  aws-agent-toolkit-for-aws = pkgs.stdenvNoCC.mkDerivation {
    pname = "aws-agent-toolkit-for-aws";
    version = "0-unstable-2026-06-03";

    src = pkgs.fetchFromGitHub {
      owner = "aws";
      repo = "agent-toolkit-for-aws";
      rev = "df13dea64baaa1b7031b25d1b2f380756131efec";
      hash = "sha256-LuUkZS0anep1bbrybbu7KCZsTVLP5/nbQN6Ivl6PLv0=";
    };

    installPhase = ''
      runHook preInstall
      cp -R . "$out"
      runHook postInstall
    '';
  };

  lean-ctx = pkgs.stdenvNoCC.mkDerivation {
    pname = "lean-ctx";
    version = "v3.7.5";

    src = pkgs.fetchFromGitHub {
      owner = "yvgude";
      repo = "lean-ctx";
      ref = "refs/tags/v3.7.5";
      hash = "sha256-1i7jr4w34bpgls0qzvjsk8wks7imb27h0wf6kjxv1idcsd64716w";
    };

    installPhase = ''
      runHook preInstall
      cp -R . "$out"
      runHook postInstall
    '';
  };
}
