{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "dbxcli";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dbxcli";
    tag = "v${version}";
    hash = "sha256-fk7aWpQ2GjREvJ7FHov0vwTKZwJuP4QM3qjzny5p7SI=";
  };

  vendorHash = "sha256-fJZX79BYkfISdrCNmYfBZoANxh7gXNEP10M2YuGvvRA=";

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
