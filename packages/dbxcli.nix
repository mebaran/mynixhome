{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "dbxcli";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dbxcli";
    tag = "v${version}";
    hash = "sha256-KgsR6YRHzFHYXjfb/rRwxVlMKoUX/cfh8p0ULE7c2+o=";
  };

  vendorHash = "sha256-R7IHN9ycoFhFOHHay4xY2xiquJod711HneorsdbNDaI=";

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
