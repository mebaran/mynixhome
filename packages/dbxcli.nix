{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "dbxcli";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dbxcli";
    tag = "v${version}";
    hash = "sha256-NXF17pNt13bF21OfzYj0OT8H+ivuLYB6/lIWoh9j9mU=";
  };

  vendorHash = "sha256-6S3qkd0dM5ZoWK3ghjQ50AYWm+cAUa3ok/r3bbcatF8=";

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
