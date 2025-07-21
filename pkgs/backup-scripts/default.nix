{ python, restic, util-linux }:

python.pkgs.buildPythonPackage {
  pname = "backup-scripts";
  version = "0.0.0";
  src = ./.;
  pyproject = true;
  build-system = [ python.pkgs.setuptools ];
  propagatedBuildInputs = [
    python.pkgs.click
    restic
    util-linux # blkid
  ];
}
