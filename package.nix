{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication {
  pname = "free-claude-code";
  version = "4.20.0-unstable-2026-09-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "0fb3b18ca8a21639ba7d1c2f11901217434eab6b";
    hash = "sha256-+89FyqN7Rff6PgCqbJVs0cp+wSjlHO1JneXYf+ZE3Hw=";
  };

  build-system = [ python314.pkgs.hatchling ];

  dependencies = with python314.pkgs; [
    aiohttp
    discordpy
    fastapi
    google-auth
    httpx
    httpx2
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
    "google-auth"
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
