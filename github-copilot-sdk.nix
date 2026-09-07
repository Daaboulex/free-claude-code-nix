{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  pydantic,
  python-dateutil,
}:

let
  version = "1.0.13";
in
buildPythonPackage {
  pname = "github-copilot-sdk";
  inherit version;
  format = "wheel";

  src = fetchPypi {
    pname = "github_copilot_sdk";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-lB3VtVzzK6Vcc8ZRBSpKUrJZtHDGi/amrD0kDCNUAsk=";
  };

  dependencies = [
    httpx
    pydantic
    python-dateutil
  ];

  pythonImportsCheck = [ "copilot" ];

  meta = {
    description = "Python SDK for GitHub Copilot CLI";
    homepage = "https://github.com/github/copilot-sdk";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
