{pkgs, ...}: let
  # 25.03.19 is the last known-good release; newer snapshots regress the
  # interactive completion behavior this configuration relies on.
  zshAutocomplete = pkgs.zsh-autocomplete.overrideAttrs (_: {
    version = "25.03.19";
    src = pkgs.fetchurl {
      url = "https://github.com/marlonrichert/zsh-autocomplete/archive/a76f26ae25528e76ee53df98ad38fbacdf89fd2e.tar.gz";
      hash = "sha256-oBSDpCLCqsg7wvvrcImzYILWxA9sYZ12/Bt5RxfSPZk=";
    };
  });
in {
  programs = {
    zsh = {
      enable = true;
      enableVteIntegration = true;
      enableCompletion = false;
      syntaxHighlighting.enable = true;
      localVariables.DIRSTACKSIZE = 30;
      setOptions = [
        "AUTO_PUSHD"
        "PUSHD_IGNORE_DUPS"
        "PUSHD_SILENT"
        "HIST_VERIFY"
        "HIST_REDUCE_BLANKS"
      ];
      history = {
        extended = true;
        append = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      plugins = with pkgs; [
        {
          name = "zsh-autocomplete";
          src = "${zshAutocomplete}/share/zsh-autocomplete";
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

        # The Pi env-theme extension falls back to tokyo-city when this is
        # unset or names a theme that Pi did not discover.
        if [[ -z "''${PI_THEME:-}" && -r "$HOME/.pi/agent/themes/noctalia.json" ]]; then
          export PI_THEME=noctalia
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

        # Expand bang history on Space so expansions are visible before execution.
        bindkey ' ' magic-space

        # AGKOZAK Config
        export AGKOZAK_BLANK_LINES=1
        autoload promptinit; promptinit
        prompt agkozak-zsh-prompt
      '';
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      # Keep normal Up-arrow history; Atuin owns only Ctrl-R.
      flags = ["--disable-up-arrow"];
      settings = {
        # Start local-only. Sync can be enabled later after explicitly logging in.
        auto_sync = false;
        update_check = false;

        search_mode = "fuzzy";
        filter_mode = "global";
        workspaces = true;

        style = "compact";
        inline_height = 20;
        show_preview = true;

        # Put the selected command on the prompt for review rather than running it.
        enter_accept = false;
      };
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
