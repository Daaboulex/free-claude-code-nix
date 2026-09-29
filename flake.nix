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
      url = "github:Daaboulex/nix-packaging-standard?ref=v2.40.1";
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
          packages.default = (pkgs.extend self.overlays.default).free-claude-code;

          checks.smoke = pkgs.runCommand "free-claude-code-smoke" { } ''
            ${self'.packages.default}/bin/fcc-server --version
            sp="$(echo ${self'.packages.default}/lib/python*/site-packages)"
            for f in \
              free_claude_code/api/admin_static/index.html \
              free_claude_code/api/admin_static/admin.css \
              free_claude_code/api/admin_static/admin.js; do
              test -f "$sp/$f" || {
                echo "missing from the installed package: $f"
                exit 1
              }
            done
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

      flake.overlays =
        let
          glueOverlay = final: _prev: {
            free-claude-code = final.callPackage ./package.nix { };
          };
          dir = ./overlays;
          names = if builtins.pathExists dir then builtins.attrNames (builtins.readDir dir) else [ ];
          fixOverlays = map (n: (import (dir + "/${n}")).overlay) (
            builtins.filter (n: inputs.nixpkgs.lib.hasSuffix ".nix" n) names
          );
        in
        {
          default = inputs.nixpkgs.lib.composeManyExtensions ([ glueOverlay ] ++ fixOverlays);
          probe = glueOverlay;
        };
      flake.homeModules.default = ./hm-module.nix;
    };
}
