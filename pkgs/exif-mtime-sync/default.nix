{ python }:

python.pkgs.buildPythonPackage {
  pname = "exif-mtime-sync";
  version = "0.0.0";
  src = ./.;
}
