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
      };
      envExtra = ''
        if [[ -f "$HOME/.zshkeys" ]]; then
          source "$HOME/.zshkeys"
        fi
      '';
      initContent = ''
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
