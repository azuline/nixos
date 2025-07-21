{ python }:

python.pkgs.buildPythonPackage {
  pname = "file-uploader";
  version = "0.0.0";
  src = ./.;
  pyproject = true;
  build-system = [ python.pkgs.setuptools ];
  propagatedBuildInputs = [
    python.pkgs.aiohttp
    python.pkgs.pyperclip
    python.pkgs.python-dotenv
  ];
}
