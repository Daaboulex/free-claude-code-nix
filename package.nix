{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication {
  pname = "free-claude-code";
  version = "4.20.0-unstable-2026-09-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "e632c85b9765ca1a2e18f7bc7ec1b003729740f6";
    hash = "sha256-YUEhMoAsmM8x1t7DcgFoyNLpgX2nvNDU4ozCBsmX4eA=";
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
