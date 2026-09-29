{
  meta = {
    reason = "nvidia-riva-client is not packaged in nixpkgs; free-claude-code imports it only inside the NVIDIA NIM voice transcription function, so the requirement is removed and NIM voice fails only when used";
    added = "2026-09-29";
    upstream = "https://github.com/Alishahryar1/free-claude-code/blob/9e239055819e5dd6135680c4df71275578f25e21/src/free_claude_code/providers/nvidia_nim/voice.py#L69";
  };
  dropWhen =
    pkgs:
    pkgs.python314Packages ? nvidia-riva-client
    && (builtins.tryEval pkgs.python314Packages.nvidia-riva-client.drvPath).success;
  overlay = _final: prev: {
    free-claude-code = prev.free-claude-code.overridePythonAttrs (old: {
      pythonRemoveDeps = (old.pythonRemoveDeps or [ ]) ++ [ "nvidia-riva-client" ];
    });
  };
}
