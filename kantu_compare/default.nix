{ stdenv, lib, fetchFromGitHub, cmake, opencv, imgui, glfw, fmt }:

# Should be run as LD_LIBRARY_PATH=/usr/lib result/KantuCompareApp on Archlinux
stdenv.mkDerivation rec {
  pname = "kantu_compare";
  version = "3";

  src = fetchFromGitHub {
    owner = "zchrissirhcz";
    repo = "KantuCompare";
    rev = "v${version}";
    sha256 = "sha256-gqYJmrTYlDqbNLfqauaRr0GGsj7wTK0ZFS8SVoJ8ZgI=";
  };

  portable-file-dialogs = fetchFromGitHub {
    owner = "samhocevar";
    repo = "portable-file-dialogs";
    rev = "main";
    sha256 = "sha256-m2cIK+6V8Dtk++W4I2wHAeQo2DYxpMv+JD2Anrn0LF0=";
  };

  # https://github.com/ocornut/str
  str = fetchFromGitHub {
    owner = "ocornut";
    repo = "str";
    rev = "master";
    sha256 = "sha256-7JVrIyELKSsWBlbBaoh+Yho/I5xe6T41LUpEXPNEaKU=";
  };

  # https://github.com/scarsty/mlcc
  mlcc = fetchFromGitHub {
    owner = "scarsty";
    repo = "mlcc";
    rev = "master";
    sha256 = "sha256-uiulWB5cC5655yRl6IouiRaUJ92gN3+1nxGfbqQnjOU=";
  };

  patchPhase = ''
    cp ${./deps.cmake} cmake/deps.cmake
    mkdir -p deps
    cp -r ${str} deps/str
    cp -r ${mlcc} deps/mlcc
  '';

  buildInputs = [ opencv glfw imgui fmt ];
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DIMGUI_DIR=${imgui}/include/imgui"
    "-Dportable_file_dialogs_src_dir=${portable-file-dialogs}"
    "-DKANTU_TESTING=OFF"
  ];
  doCheck = false;

  meta = with lib; {
    description = "Visual comparison for YUV and JPG/PNG images.";
    homepage = "https://github.com/zchrissirhcz/KantuCompare";
    license = licenses.mit;
    platforms = platforms.all;              
  };
}
