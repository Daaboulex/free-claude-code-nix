{
  description = "Nix flake for free-claude-code - Anthropic-compatible local proxy for Claude Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:Daaboulex/nix-packaging-standard?ref=v2.18.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          packages.default = pkgs.callPackage ./package.nix { };

          checks.smoke = pkgs.runCommand "free-claude-code-smoke" { } ''
            ${self'.packages.default}/bin/fcc-server --version
            sp="$(echo ${self'.packages.default}/lib/python*/site-packages)"
            test -f "$sp/free_claude_code/api/admin_static/index.html"
            test -f "$sp/free_claude_code/api/admin_static/admin.css"
            test -f "$sp/free_claude_code/api/admin_static/admin.js"
            test -f "$sp/free_claude_code/config/env.example"
            touch "$out"
          '';

          checks.module-eval-hm = inputs.std.lib.homeModuleCheck {
            inherit (inputs) nixpkgs home-manager;
            inherit system;
            overlays = [ self.overlays.default ];
            module = ./hm-module.nix;
            config.services.free-claude-code.enable = true;
          };
        };

      flake.overlays.default = final: _prev: {
        free-claude-code = inputs.self.packages.${final.stdenv.hostPlatform.system}.default;
      };
      flake.homeManagerModules.default = ./hm-module.nix;
    };
}
