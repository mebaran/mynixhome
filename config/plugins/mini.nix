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
  keymaps = let
      pick = p: {
        __raw = "require('mini.pick').${p}";
      };
      extra = p: {
        __raw = "require('mini.extra').${p}";
      };
    in [
      {
        key = "<leader>ff";
        action = pick "builtin.files";
        options.desc = "Pick files";
      }
      {
        key = "<leader>bb";
        action = pick "builtin.buffers";
        options.desc = "Pick buffers";
      }
      {
        key = "<leader>sg";
        action = pick "builtin.grep_live";
        options.desc = "Pick by grep (live)";
      }
      {
        key = "<leader>\"";
        action = extra "pickers.registers";
        options.desc = "Pick registers";
      }
      {
        key = "<leader>sl";
        action = extra "pickers.lsp";
        options.desc = "Pick LSP symbols";
      }
      {
        key = "<leader>sk";
        action = extra "pickers.keymaps";
        options.desc = "Pick keymaps";
      }
      {
        key = "<leader>fo";
        action = extra "pickers.oldfiles";
        options.desc = "Pick oldfiles";
      }
      {
        key = "<leader>sc";
        action = extra "pickers.treesitter";
        options.desc = "Pick code (nodes)";
      }
      {
        key = "<leader>sc";
        action = "lua ${(extra ''pickers.history({ scope = ":" })'').__raw}";
        options.desc = "Pick command (history)";
      }
      {
        key = "<leader>s/";
        action = "lua ${(extra ''pickers.history({ scope = "/" })'').__raw}";
        options.desc = "Pick command (search)";
      }
    ];
}
