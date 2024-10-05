{ stdenv,
  fetchFromGitHub,
  writeText,
  autoreconfHook,
  pkg-config,
  pandoc,
  graphviz,
  gsl,
  igraph,
  lib
}:

stdenv.mkDerivation {
  pname = "ggen";
  version = "3903b8";

  src = fetchFromGitHub {
    owner = "cordeiro";
    repo = "ggen";
    rev = "master";
    sha256 = "sha256-O83xhFEAoMAHAFkuapTW2Uvz5KIohKK6MV9IrJEAMbs=";
  };

  VERSION_M4 = writeText "version.m4" "m4_define([VERSION_NUMBER], [3903b8])";
  CFLAGS = "-std=c99";

  postPatch = ''
    cp $VERSION_M4 version.m4
    sed -i 's/AM_INIT_AUTOMAKE(\[-Wall -Werror gnu\])/AM_INIT_AUTOMAKE([-Wall gnu subdir-objects])/g' configure.ac
    # sed -i 's/igraph_get_eid(\([^)]*\))/igraph_get_eid(\1,true)/g' src/utils.c
    # sed -i 's/igraph_adjacency(\([^)]*\))/igraph_adjacency(\1,IGRAPH_NO_LOOPS)/g' src/graph-generation.c
  '';

  #autoreconfPhase = "./autogen.sh";

  nativeBuildInputs = [ autoreconfHook pkg-config pandoc ];
  buildInputs = [ graphviz gsl igraph ];
  doCheck = true;

  meta = with lib; {
    description = "a library for the creation of randomly generated workloads for scheduling simulations";
    homepage = "https://github.com/cordeiro/ggen";
    platforms = platforms.all;              
    #broken = true; # igraph is too new in nixpkgs
  };
}
