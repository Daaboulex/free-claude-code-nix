{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication {
  pname = "free-claude-code";
  version = "4.12.0-unstable-2026-08-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "c216e9a02e8732ba9b42db3779be1cd3e7b51fcb";
    hash = "sha256-/NNBkmDSpseWbYHyaNUBgstMplM6N6fxEo2CDtJzulM=";
  };

  build-system = [ python314.pkgs.hatchling ];

  dependencies = with python314.pkgs; [
    aiohttp
    discordpy
    fastapi
    google-auth
    httpx
    jsonschema
    loguru
    markdown-it-py
    openai
    pydantic
    pydantic-settings
    pysocks
    python-dotenv
    python-telegram-bot
    requests
    socksio
    tiktoken
    uvicorn
  ];

  pythonRelaxDeps = [
    "discord.py"
    "fastapi"
    "markdown-it-py"
    "openai"
    "pydantic-settings"
    "python-telegram-bot"
    "tiktoken"
    "uvicorn"
  ];

  pythonImportsCheck = [ "free_claude_code" ];

  meta = {
    description = "Anthropic-compatible local proxy fronting Claude Code with any model backend";
    homepage = "https://github.com/Alishahryar1/free-claude-code";
    license = lib.licenses.mit;
    mainProgram = "fcc-server";
    platforms = lib.platforms.linux;
  };
}
