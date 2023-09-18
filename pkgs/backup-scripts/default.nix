{ python }:

python.pkgs.buildPythonPackage {
  pname = "backup-scripts";
  version = "0.0.0";
  src = ./.;
  propagatedBuildInputs = [
    python.pkgs.click
  ];
}
