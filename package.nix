{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication (finalAttrs: {
  pname = "free-claude-code";
  version = "6.5.4-unstable-2026-09-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alishahryar1";
    repo = "free-claude-code";
    rev = "9e239055819e5dd6135680c4df71275578f25e21";
    hash = "sha256-XtJEGDYoul38IWKZnad7xiWekxnXJNA3TP3TxylBaKY=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = lib.head (lib.splitString "-unstable-" finalAttrs.version);

  build-system = with python314.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python314.pkgs; [
    aiohttp
    discordpy
    fastapi
    (callPackage ./github-copilot-sdk.nix { })
    google-auth
    grpcio
    grpcio-tools
    httpx
    httpx2
    json5
    jsonschema
    loguru
    markdown-it-py
    openai
    packaging
    pydantic
    pyperclip
    pysocks
    python-dotenv
    python-telegram-bot
    requests
    simplejson
    socksio
    sqlalchemy
    tiktoken
    tomlkit
    uvicorn
  ];

  pythonImportsCheck = [ "free_claude_code" ];

  meta = {
    description = "Anthropic-compatible local proxy fronting Claude Code with any model backend";
    homepage = "https://github.com/Alishahryar1/free-claude-code";
    license = lib.licenses.agpl3Only;
    mainProgram = "fcc-server";
    platforms = lib.platforms.linux;
  };
})
