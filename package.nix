{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication {
  pname = "free-claude-code";
  version = "4.12.0-unstable-2026-07-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "7a3d15826251f2c4c4e3382c3249ff38eba0cc8d";
    hash = "sha256-Tmz7RPsUGxlBpIEETQyqrJ8qNrC2V391y00uu+gfR1Y=";
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
