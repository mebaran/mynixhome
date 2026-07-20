{
  pkgs,
  lib,
  ...
}: let
  mkZellijWasmPlugin = {
    pname,
    version,
    url,
    hash,
  }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl {inherit url hash;};
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/
        cp $src $out/${pname}.wasm
      '';
    };
  zellij-forgot = mkZellijWasmPlugin rec {
    pname = "zellij-forgot";
    version = "0.4.1";
    url = "https://github.com/karimould/zellij-forgot/releases/download/${version}/zellij_forgot.wasm";
    hash = "sha256-kBGZG+I9PMKhXtyAy6XRW4Sqht0/RCDcv86p0WjxvN8=";
  };
  zellij-what-time = mkZellijWasmPlugin rec {
    pname = "zellij-what-time";
    version = "0.1.1";
    url = "https://github.com/pirafrank/zellij-what-time/releases/download/${version}/zellij-what-time.wasm";
    hash = "sha256-EseRfAWVHQXwPli5SwOKkJgS0GB79dqJxSAqqZAONrA=";
  };
  zjstatus = mkZellijWasmPlugin rec {
    pname = "zjstatus";
    version = "v0.24.0";
    url = "https://github.com/dj95/zjstatus/releases/download/${version}/zjstatus.wasm";
    hash = "sha256-HM7ezh3tYs8+IJvmkM3TnKb7noIo7XGpUfZQf5lWZps=";
  };
  zellij-autolock = mkZellijWasmPlugin rec {
    pname = "zellij-autolock";
    version = "0.2.2";
    url = "https://github.com/fresh2dev/zellij-autolock/releases/download/${version}/zellij-autolock.wasm";
    hash = "sha256-aclWB7/ZfgddZ2KkT9vHA6gqPEkJ27vkOVLwIEh7jqQ=";
  };
  zellij-adopt = pkgs.writeShellApplication {
    name = "zellij-adopt";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
      procps
      reptyr
      television
    ];
    text = ''
      set -euo pipefail

      usage() {
        cat <<'EOF'
      Usage: zellij-adopt [--terminal|-T] [--stdio|-s] [PID]

      Fuzzy-pick a running process and adopt it into the current terminal with reptyr.

      Options:
        -T, --terminal  steal the whole terminal session for the selected process
        -s, --stdio     attach stdio fds even if the target is not attached to a tty
        -h, --help      show this help

      Tip: run inside a fresh Zellij pane. If adoption fails on Linux, you may need:
        sudo sysctl kernel.yama.ptrace_scope=0
      EOF
      }

      reptyr_args=()
      while [[ $# -gt 0 ]]; do
        case "$1" in
          -T|--terminal|--tty)
            reptyr_args+=("-T")
            shift
            ;;
          -s|--stdio)
            reptyr_args+=("-s")
            shift
            ;;
          -h|--help)
            usage
            exit 0
            ;;
          --)
            shift
            break
            ;;
          *)
            break
            ;;
        esac
      done

      if [[ -z "''${ZELLIJ:-}" ]]; then
        echo "warning: zellij-adopt is intended to be run inside a Zellij pane" >&2
      fi

      pid="''${1:-}"
      if [[ -z "$pid" ]]; then
        selection="$(
          ps -eo pid=,user=,tty=,stat=,etime=,args= -ww \
            | awk -v self="$$" '
                $1 != self && $3 != "?" &&
                index($0, " zellij-adopt") == 0 &&
                index($0, " reptyr ") == 0 &&
                index($0, " fzf") == 0 &&
                index($0, " tv") == 0 {
                  print
                }
              ' \
            | tv \
                --input-prompt="adopt> " \
                --input-header="Select a TTY process to adopt into this pane. Use zellij-adopt -T to steal the whole terminal session." \
                --height=30 \
                --no-preview \
                --no-remote
        )" || exit $?
        pid="$(awk '{print $1}' <<<"$selection")"
      fi

      if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "zellij-adopt: expected a numeric PID, got: $pid" >&2
        exit 2
      fi

      if [[ -r /proc/sys/kernel/yama/ptrace_scope ]]; then
        ptrace_scope="$(cat /proc/sys/kernel/yama/ptrace_scope)"
        if [[ "$ptrace_scope" != "0" ]]; then
          cat >&2 <<EOF
      note: kernel.yama.ptrace_scope is $ptrace_scope; reptyr may be blocked.
            If adoption fails, temporarily allow it with:
              sudo sysctl kernel.yama.ptrace_scope=0
      EOF
        fi
      fi

      echo "Adopting PID $pid with: reptyr ''${reptyr_args[*]:-}<default>" >&2
      if ! reptyr "''${reptyr_args[@]}" "$pid"; then
        cat >&2 <<'EOF'

      reptyr failed. Things to try:
        - zellij-adopt -T        # often better for shells/process groups
        - sudo sysctl kernel.yama.ptrace_scope=0
        - make sure you own the target process and it is attached to a TTY
      EOF
        exit 1
      fi
    '';
  };
  aliasPlugin = a: p: ''${a} location="file:${p}/${p.pname}.wasm"'';
in {
  home.packages = [
    pkgs.reptyr
    pkgs.television
    zellij-adopt
  ];

  programs.zsh.shellAliases = {
    zadopt = "zellij-adopt";
    zsteal = "zellij-adopt --terminal";
  };

  programs.zellij = {
    enable = true;
    settings = {
      # Zellij is easier to learn with visible affordances: show pane titles,
      # richer plugin UI, startup tips, and the compact-bar hover cheatsheet.
      simplified_ui = false;
      pane_frames = true;
      show_startup_tips = true;
    };
  };
  xdg.configFile."zellij/config.kdl".text = lib.strings.concatLines [
    ''
      plugins {
        ${aliasPlugin "forgot" zellij-forgot}
        ${aliasPlugin "what-time" zellij-what-time}
        ${aliasPlugin "zjstatus" zjstatus}
        compact-bar location="zellij:compact-bar" {
          // Keep Zellij's built-in hover helper available alongside zjstatus.
          tooltip "F1"
        }
        autolock location="file:${zellij-autolock}/${zellij-autolock.pname}.wasm" {
          is_enabled true
          triggers "nvim|vim|hx|git|lazygit|fzf|tv|zoxide|atuin|yazi|less|man|ssh|pi|codex|opencode"
          reaction_seconds "0.2"
        }
      }

      load_plugins {
        autolock
        compact-bar
      }
    ''
    (builtins.readFile ./config.kdl)
  ];
  xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
}
