{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication {
  pname = "free-claude-code";
  version = "4.20.0-unstable-2026-09-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "78a9364db66e3fc5f8fd54e83e49b934e503dc7f";
    hash = "sha256-3YaqChbnCbZQdapKU2H/k6suKIGdTV460o1j7MGpvj0=";
  };

  build-system = [ python314.pkgs.hatchling ];

  dependencies = with python314.pkgs; [
    aiohttp
    discordpy
    fastapi
    (callPackage ./github-copilot-sdk.nix { })
    google-auth
    httpx
    httpx2
    json5
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
    simplejson
    socksio
    tiktoken
    tomlkit
    uvicorn
  ];

  pythonRelaxDeps = [
    "anyio"
    "discord.py"
    "fastapi"
    "google-auth"
    "json5"
    "markdown-it-py"
    "openai"
    "pydantic"
    "pydantic-settings"
    "python-telegram-bot"
    "simplejson"
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
