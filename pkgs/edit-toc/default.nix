{ python, pdftk }:

python.pkgs.buildPythonPackage {
  pname = "edit-toc";
  version = "0.0.0";
  src = ./.;
  pyproject = true;
  build-system = [ python.pkgs.setuptools ];
  propagatedBuildInputs = [
    python.pkgs.click
    pdftk
  ];
}
