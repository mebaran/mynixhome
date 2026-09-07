{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "dbxcli";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "dbxcli";
    tag = "v${version}";
    hash = "sha256-B3TemUS9tHR5qJWGBBdlXVme9+Ix/u6IwsKYtZUVhcs=";
  };

  vendorHash = "sha256-ArD29fOqsXi5NZczrlM9wuShziFg1MdCB22tQNlpB8I=";

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
