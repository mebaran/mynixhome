{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "dbxcli";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dbxcli";
    tag = "v${version}";
    hash = "sha256-JL+2dbm3DgZBAj3aZww97jBkY+R1SCWlFtGrOOod2Oc=";
  };

  vendorHash = "sha256-/avyOomsnlvZtfqYA0JVHeUi9aNoNQn6DXhtR0qiCDg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Command-line client for Dropbox";
    homepage = "https://github.com/dropbox/dbxcli";
    license = lib.licenses.asl20;
    mainProgram = "dbxcli";
  };
}
