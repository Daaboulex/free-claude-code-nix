# free-claude-code (Nix)

<!-- BEGIN generated:badges -->
[![CI](https://github.com/Daaboulex/free-claude-code-nix/actions/workflows/ci.yml/badge.svg)](https://github.com/Daaboulex/free-claude-code-nix/actions/workflows/ci.yml)
[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
<!-- END generated:badges -->

Nix flake packaging for [free-claude-code](https://github.com/Alishahryar1/free-claude-code) by [Ali Khokhar (Alishahryar1)](https://github.com/Alishahryar1) - a local Anthropic-compatible FastAPI proxy that fronts Claude Code (and other coding agents) with any OpenAI-compatible model backend.

<!-- BEGIN generated:upstream -->
## Upstream

| | |
|---|---|
| **Project** | [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code) |
| **License** | MIT |
| **Tracked** | GitHub commits (`main`) |

<!-- END generated:upstream -->

## What Is This?

A Nix flake that builds free-claude-code from a pinned upstream commit, plus a Home Manager module that runs `fcc-server` as a user service and ships an `fcc` launcher wired to it.

- **Package** - `fcc-server`, `fcc-claude`, `fcc-cline`, `fcc-codex`, `fcc-desktop`, `fcc-hermes`, `fcc-opencode`, `fcc-pi` entry points from a hatchling wheel on Python 3.14
- **Home Manager module** - `services.free-claude-code`: a loopback-bound `fcc-server` user service plus the `fcc` launcher pointing Claude Code at it
- **Update automation** - daily upstream commit detection, hash recomputation, and a verified build

<!-- BEGIN generated:installation -->
## Installation

Add as a flake input:

```nix
{
  inputs.free-claude-code = {
    url = "github:Daaboulex/free-claude-code-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then add the overlay:

```nix
nixpkgs.overlays = [ inputs.free-claude-code.overlays.default ];
```

<!-- END generated:installation -->

## Home Manager Module

```nix
home-manager.sharedModules = [ inputs.free-claude-code.homeModules.default ];
```

```nix
services.free-claude-code.enable = true;
```

| Option | Default | Description |
|--------|---------|-------------|
| `enable` | `false` | Enable the module |
| `package` | `pkgs.free-claude-code` | Package to run (provided by the overlay) |
| `host` | `"127.0.0.1"` | Address `fcc-server` binds (`HOST`) |
| `port` | `8082` | Port `fcc-server` listens on (`PORT`) |
| `claudeConfigDir` | `"~/.claude-fcc"` | `CLAUDE_CONFIG_DIR` the `fcc` launcher exports |
| `autostart` | `false` | Start the service at login; when false the `fcc` launcher starts it on demand |

The service binds loopback by default and no firewall options are provided; keeping it local is the security posture. An empty `ANTHROPIC_AUTH_TOKEN` disables proxy auth.

## Usage

Runtime configuration lives in `~/.fcc/.env` (process environment overrides it):

```bash
mkdir -p ~/.fcc
printf '%s\n' 'DEEPSEEK_API_KEY=sk-your-key' 'MODEL=deepseek/deepseek-chat' > ~/.fcc/.env
systemctl --user start free-claude-code
fcc
```

`fcc` exports `CLAUDE_CONFIG_DIR` plus the service's `HOST`/`PORT` and execs `fcc-claude`, which points Claude Code at the running proxy.

## Development

```bash
git clone https://github.com/Daaboulex/free-claude-code-nix
cd free-claude-code-nix
nix build
./result/bin/fcc-server --version
```

## Updates

Upstream publishes no tags, so this repo is commit-tracked: daily automation reads upstream `main`, bumps `rev` and the source hash while the `version` literal mirrors upstream's `pyproject.toml`, rebuilds, and verifies `fcc-server --version` before pushing. Weekly maintenance refreshes `flake.lock` and prunes stale branches.

## License

This Nix packaging repo is MIT licensed (see `LICENSE`). The upstream [free-claude-code](https://github.com/Alishahryar1/free-claude-code) project is MIT licensed as well.

<!-- BEGIN generated:footer -->
<!-- END generated:footer -->
