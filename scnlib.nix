{ stdenv, fetchFromGitHub, cmake, doctest, lib }:

stdenv.mkDerivation rec {
  pname = "scnlib";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "eliaskosunen";
    repo = "scnlib";
    rev = "v${version}";
    sha256 = "sha256-SCi70Ag5mPbOzfORa9wI2h93ufHen0376UYoy+psNF8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake doctest ];
  cmakeFlags = [ "-DSCN_BENCHMARKS=off" ];
  doCheck = true;

  meta = with lib; {
    description = "scanf for modern C++";
    homepage = "https://github.com/eliaskosunen/scnlib";
    license = licenses.asl20;
    platforms = platforms.all;              
  };
}
