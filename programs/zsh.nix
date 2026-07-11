{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableVteIntegration = true;
      enableCompletion = false;
      syntaxHighlighting.enable = true;
      history = {
        extended = true;
        append = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      plugins = with pkgs; [
        {
          name = "zsh-autocomplete";
          src = "${zsh-autocomplete}/share/zsh-autocomplete";
        }
        {
          name = "agkozak-zsh-prompt";
          src = "${agkozak-zsh-prompt}/share/zsh/site-functions";
        }
      ];
      shellAliases = {
        j = "z";
        e = "$EDITOR";
        keeper = "uvx --from keepercommander keeper";
      };
      envExtra = ''
        if [[ -f "$HOME/.zshkeys" ]]; then
          source "$HOME/.zshkeys"
        fi
      '';
      initContent = ''
        aws-login() {
          local profile="''${1:-''${AWS_PROFILE:-default}}"
          local region="''${2:-''${AWS_DEFAULT_REGION:-us-west-2}}"
          local credentials_output
          local credentials_status

          export AWS_PROFILE="$profile"
          export AWS_SDK_LOAD_CONFIG=1

          export AWS_DEFAULT_REGION="$region"
          export AWS_REGION="$region"

          aws login --profile "$profile" || aws sso login --profile "$profile" || return

          credentials_output="$(
            AWS_PROFILE="$profile" aws configure export-credentials \
              --profile "$profile" \
              --format env \
              --no-cli-pager 2>&1
          )"
          credentials_status=$?

          if [[ "$credentials_status" -ne 0 ]]; then
            echo "failed to export AWS credentials for profile '$profile'" >&2
            echo "$credentials_output" >&2
            return "$credentials_status"
          fi

          eval "$credentials_output"
          echo "Loaded AWS credentials for profile '$profile'" >&2
        }

        if [[ -n "$KITTY_WINDOW_ID" ]]; then
          alias ssh="kitten ssh"
        fi

        # ZSH Autocomplete Config
        zstyle ':autocomplete:*' min-input 999
        bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
        bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

        # AGKOZAK Config
        export AGKOZAK_BLANK_LINES=1
        autoload promptinit; promptinit
        prompt agkozak-zsh-prompt
      '';
    };

    # setup zsh autocomplete plugin
    zoxide = {
      enable = true;
      options = [
        "--cmd d"
      ];
    };

    z-lua = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "enhanced"
      ];
    };
  };
}
