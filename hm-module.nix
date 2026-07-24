{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.free-claude-code;
  bindEnvFile = pkgs.writeText "free-claude-code-bind.env" ''
    HOST=${cfg.host}
    PORT=${toString cfg.port}
  '';
in
{
  options.services.free-claude-code = {
    enable = lib.mkEnableOption "free-claude-code proxy server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.free-claude-code;
      defaultText = lib.literalExpression "pkgs.free-claude-code";
      description = "The free-claude-code package to use.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address fcc-server binds.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Port fcc-server listens on.";
    };

    claudeConfigDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.claude-fcc";
      description = "CLAUDE_CONFIG_DIR exported by the fcc launcher.";
    };

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start fcc-server at login; when false the fcc launcher starts it on demand.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.free-claude-code = {
      Unit.Description = "free-claude-code proxy server";

      Service = {
        ExecStart = "${cfg.package}/bin/fcc-server";
        Environment = [
          "HOST=${cfg.host}"
          "PORT=${toString cfg.port}"
        ];
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = lib.mkIf cfg.autostart {
        WantedBy = [ "default.target" ];
      };
    };

    home.packages = [
      cfg.package
      (pkgs.writeShellApplication {
        name = "fcc";
        runtimeInputs = [
          pkgs.systemd
          pkgs.curl
          pkgs.coreutils
        ];
        text = ''
          export CLAUDE_CONFIG_DIR="${cfg.claudeConfigDir}"
          export FCC_ENV_FILE="${bindEnvFile}"
          if ! systemctl --user is-active --quiet free-claude-code.service; then
            systemctl --user start free-claude-code.service
          fi
          tries=0
          until curl -fsS -o /dev/null "http://${cfg.host}:${toString cfg.port}/health"; do
            tries=$((tries + 1))
            if [ "$tries" -ge 50 ]; then
              echo "fcc: free-claude-code is not healthy on ${cfg.host}:${toString cfg.port}; check: systemctl --user status free-claude-code" >&2
              exit 1
            fi
            sleep 0.2
          done
          exec ${cfg.package}/bin/fcc-claude "$@"
        '';
      })
    ];
  };
}
