{
  pkgs,
  lib,
  ...
}: let
  trim = lib.strings.trimWith {
    start = true;
    end = true;
  };
  makeFuzzelScript = {
    name,
    action,
    prompt,
    application,
    basedir ? "$HOME",
    inputs ? [],
  }: let
    fuzzelCmd = ''fuzzel -d -p "${prompt}"'';
  in
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [pkgs.fuzzel] ++ inputs;
      text = ''
        cd "${basedir}"
        function action {
          ${action}
        }
        RESULT=$(
          action | ${fuzzelCmd}
        )
        ${trim application}
      '';
    };
in {
  programs.fuzzel = {
    enable = true;
  };
  home.packages = [
    (makeFuzzelScript {
      name = "fuzzel-rooter";
      prompt = "Open terminal at > ";
      action = ''
        fd '^.git$' --hidden --type d -x echo -e '{//}' | while read -r d; do
          printf "%s:\t%s\n" "$(basename "$d")" "$d"
        done | column -t -s $'\t' | sort
      '';
      application = ''
        TARGET=$(head -n 1 <<< "$RESULT" | awk -F": +" '{print $2}')
        echo "Opening ghostty in $TARGET..."
        ghostty --working-directory="$TARGET"
      '';
      inputs = [pkgs.fd pkgs.ghostty];
    })
    (makeFuzzelScript {
      name = "fuzzel-home";
      prompt = "Open 🏠 directory > ";
      action = ''fd --type d --max-depth 1 -x basename '{/}' | sort'';
      application = ''xdg-open "$HOME"/"$RESULT"'';
      inputs = [pkgs.fd];
    })
  ];
}
