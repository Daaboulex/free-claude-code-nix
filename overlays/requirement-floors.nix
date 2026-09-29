{
  meta = {
    reason = "free-claude-code's requirement floors run ahead of the versions nixpkgs ships, so pythonRuntimeDepsCheck refuses the build until nixpkgs meets every floor this relaxes";
    added = "2026-09-29";
    upstream = "https://github.com/Alishahryar1/free-claude-code/blob/9e239055819e5dd6135680c4df71275578f25e21/pyproject.toml";
  };
  dropWhenBuilds =
    pkgs:
    pkgs.free-claude-code.overridePythonAttrs {
      pythonRemoveDeps = [ "nvidia-riva-client" ];
    };
  overlay = _final: prev: {
    free-claude-code = prev.free-claude-code.overridePythonAttrs (old: {
      pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [
        "anyio"
        "discord.py"
        "google-auth"
        "grpcio"
        "json5"
        "openai"
        "packaging"
        "pydantic"
        "python-telegram-bot"
        "simplejson"
        "sqlalchemy"
        "tiktoken"
        "uvicorn"
      ];
    });
  };
}
