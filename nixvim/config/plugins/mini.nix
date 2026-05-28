{lib, ...}: let
  raw = lib.nixvim.mkRaw;
in {
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

          # Built-in completion
          {
            mode = "i";
            keys = "<C-x>";
          }

          # `g` key
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
          (raw "${clue}.gen_clues.builtin_completion()")
          (raw "${clue}.gen_clues.g()")
          (raw "${clue}.gen_clues.marks()")
          (raw "${clue}.gen_clues.registers()")
          (raw "${clue}.gen_clues.windows()")
          (raw "${clue}.gen_clues.z()")

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
      diff = {};
      extra = {};
      files = {};
      icons = {};
      indentscope = {
        try_as_border = true;
      };
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
      visits = {};
    };
    luaConfig.post = builtins.readFile ./lua/mini.lua;
  };
  keymaps = [
    {
      key = "<leader>ff";
      action = raw "MiniPick.builtin.files";
      options.desc = "Pick files";
    }
    {
      key = "<leader>fe";
      action = raw "MiniExtra.pickers.explorer";
      options.desc = "Pick file explorer";
    }
    {
      key = "<leader>fv";
      action = raw "MiniExtra.pickers.visit_paths";
      options.desc = "Pick frecent files";
    }
    {
      key = "<leader>fl";
      action = raw "MiniExtra.pickers.visit_labels";
      options.desc = "Pick frecent labels";
    }
    {
      key = "<leader>bb";
      action = raw "MiniPick.builtin.buffers";
      options.desc = "Pick buffers";
    }
    {
      key = "<leader>sg";
      action = raw "MiniPick.builtin.grep_live";
      options.desc = "Pick by grep (live)";
    }
    {
      key = "<leader>\"";
      action = raw "MiniExtra.pickers.registers";
      options.desc = "Pick registers";
    }
    {
      key = "<leader>sl";
      action = raw "MiniExtra.pickers.lsp";
      options.desc = "Pick LSP symbols";
    }
    {
      key = "<leader>sk";
      action = raw "MiniExtra.pickers.keymaps";
      options.desc = "Pick keymaps";
    }
    {
      key = "<leader>fo";
      action = raw "MiniExtra.pickers.oldfiles";
      options.desc = "Pick oldfiles";
    }
    {
      key = "<leader>st";
      action = raw "MiniExtra.pickers.treesitter";
      options.desc = "Pick code (nodes)";
    }
    {
      key = "<leader>sc";
      action = raw "function() MiniExtra.pickers.history({ scope = ':' }) end";
      options.desc = "Pick command (history)";
    }
    {
      key = "<leader>s/";
      action = raw "function() MiniExtra.pickers.history({ scope = '/' }) end";
      options.desc = "Pick command (search)";
    }
  ];
}
