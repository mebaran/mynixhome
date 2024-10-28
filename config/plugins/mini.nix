{
  plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules = {
      basics = {
        extra_ui = true;
      };
      bufremove = {};
      bracketed = {};
      clue = {
        triggers = [
          # Leader trigger
          {
            mode = "n";
            keys = "<Leader>";
          }
          {
            mode = "x";
            keys = "<Leader>";
          }

          # Built-in completio
          {
            mode = "i";
            keys = "<C-x>";
          }

          # `g` ke
          {
            mode = "n";
            keys = "g";
          }
          {
            mode = "x";
            keys = "g";
          }

          # Mark
          {
            mode = "n";
            keys = "'";
          }
          {
            mode = "n";
            keys = "`";
          }
          {
            mode = "x";
            keys = "'";
          }
          {
            mode = "x";
            keys = "`";
          }

          # Register
          {
            mode = "n";
            keys = "\"";
          }
          {
            mode = "x";
            keys = "\"";
          }
          {
            mode = "i";
            keys = "<C-r>";
          }
          {
            mode = "c";
            keys = "<C-r>";
          }

          # Window command
          {
            mode = "n";
            keys = "<C-w>";
          }

          # `z` ke
          {
            mode = "n";
            keys = "z";
          }
          {
            mode = "x";
            keys = "z";
          }

          # `Brackets
          {
            mode = "n";
            keys = "[";
          }
          {
            mode = "n";
            keys = "]";
          }
          {
            mode = "x";
            keys = "[";
          }
          {
            mode = "x";
            keys = "]";
          }
        ];
        clues = let
          clue = "require('mini.clue')";
        in [
          # Enhance this by adding descriptions for <Leader> mapping groups
          {__raw = "${clue}.gen_clues.builtin_completion()";}
          {__raw = "${clue}.gen_clues.g()";}
          {__raw = "${clue}.gen_clues.marks()";}
          {__raw = "${clue}.gen_clues.registers()";}
          {__raw = "${clue}.gen_clues.windows()";}
          {__raw = "${clue}.gen_clues.z()";}

          # Submode for quick buffer navigation
          {
            mode = "n";
            keys = "]b";
            postkeys = "]";
          }
          {
            mode = "n";
            keys = "]w";
            postkeys = "]";
          }
          {
            mode = "n";
            keys = "[b";
            postkeys = "[";
          }
          {
            mode = "n";
            keys = "[w";
            postkeys = "[";
          }
        ];
      };
      comment = {};
      files = {};
      icons = {};
      indentscope = {
        try_as_border = true;
      };
      jump = {};
      notify = {};
      pick = {};
      pairs = {};
      starter = {};
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
    };
    luaConfig.post = builtins.readFile ./lua/mini.lua;
  };
}
