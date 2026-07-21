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
      description = "CLAUDE_CONFIG_DIR exported by the fclaudec launcher.";
    };

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to start fcc-server on login.";
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
        name = "fclaudec";
        text = ''
          export CLAUDE_CONFIG_DIR="${cfg.claudeConfigDir}"
          export FCC_ENV_FILE="${bindEnvFile}"
          exec ${cfg.package}/bin/fcc-claude "$@"
        '';
      })
    ];
  };
}
