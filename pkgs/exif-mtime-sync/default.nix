{ python, coreutils, findutils, fd, exiftool }:

python.pkgs.buildPythonPackage {
  pname = "exif-mtime-sync";
  version = "0.0.0";
  src = ./.;
  propagatedBuildInputs = [
    coreutils
    findutils
    fd
    exiftool
  ];
}
