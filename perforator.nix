{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "perforator";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "perforator";
    rev = "v${version}";
    sha256 = "sha256-DkeZIGCpXmTWAGfY+9z2n/SKpNgakZNGuASRRLQx5l4=";
  };

  vendorSha256 = lib.fakeSha256;
  subPackages = "cmd/perforator";

  GOPROXY = "https://goproxy.cn";
}
