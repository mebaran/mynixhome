{
  keymaps = [
    # Quickfix and Location list
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options = {desc = "Open Location List";};
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>copen<cr>";
      options = {desc = "Open Quickfix List";};
    }
    {
      mode = "n";
      key = "<leader>xc";
      action = "<cmd>cclose<cr>";
      options = {desc = "Close Quickfix / Location Buffer";};
    }
    {
      mode = "n";
      key = "<leader>xb";
      action = "<C-w>b<C-w>c";
      options = {desc = "Close bottom window";};
    }

    # Window resize
    {
      mode = "n";
      key = "<C-Left>";
      action = "<Cmd>vertical resize -2<CR>";
      options = {desc = "Decrease window width";};
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<Cmd>resize -2<CR>";
      options = {desc = "Decrease window height";};
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<Cmd>resize +2<CR>";
      options = {desc = "Increase window height";};
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<Cmd>vertical resize +2<CR>";
      options = {desc = "Increase window width";};
    }

    # Terminal
    {
      mode = "t";
      key = "<C-W>";
      action = ''<C-\><C-N><C-w>'';
      options = {desc = "Focus other window";};
    }
    {
      mode = "t";
      key = "<C-x>";
      action = ''<C-\><C-n>'';
      options = {desc = "Quick access to normal mode";};
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>vsplit | terminal <cr>";
      options = {desc = "Split terminal vertically";};
    }
    {
      mode = "n";
      key = "<leader>tx";
      action = "<cmd>split | terminal<cr>";
      options = {desc = "Split terminal horizontally";};
    }

    # Diagnostics
    {
      mode = "n";
      key = "<leader>e";
      action = {__raw = "vim.diagnostic.open_float";};
      options = {desc = "Open diagnostic float";};
    }
    {
      mode = "n";
      key = "[d";
      action = {__raw = "vim.diagnostic.goto_prev";};
      options = {desc = "Goto next diagnostic";};
    }
    {
      mode = "n";
      key = "]d";
      action = {__raw = "vim.diagnostic.goto_next";};
      options = {desc = "Goto previous diagnostic";};
    }
    {
      mode = "n";
      key = "<leader>q";
      action = {__raw = "vim.diagnostic.setloclist";};
      options = {desc = "Set loclist with diagnostic locations";};
    }

    # Clear search with <esc>
    {
      mode = ["i" "n"];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options = {desc = "Escape and clear hlsearch";};
    }

    # Clear search diff update and redraw
    # taken from runtime/lua/_editor.lua
    {
      mode = "n";
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = {desc = "Redraw / clear hlsearch / diff update";};
    }

    {
      mode = ["n" "x"];
      key = "gw";
      action = "*N";
      options = {desc = "Search word under cursor";};
    }

    # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    {
      mode = "n";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next search result";
      };
    }
    {
      mode = "x";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next search result";
      };
    }
    {
      mode = "o";
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next search result";
      };
    }
    {
      mode = "n";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev search result";
      };
    }
    {
      mode = "x";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev search result";
      };
    }
    {
      mode = "o";
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev search result";
      };
    }

    {
      mode = "x";
      key = ">";
      action = ">gv";
      options = {desc = "Indent selection";};
    }
    {
      mode = "x";
      key = "<";
      action = "<gv";
      options = {desc = "Unindent selection";};
    }
  ];
  autoCmd = [
    {
      event = "FileType";
      pattern = [
        "checkhealth"
        "fugitive*"
        "git"
        "help"
        "lspinfo"
        "netrw"
        "notify"
        "qf"
        "query"
        "sqls_output"
      ];
      callback = {
        __raw = ''
          function()
              vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
          end
        '';
      };
    }
    {
      event = "LspAttach";
      callback = {
        __raw = ''
          function(ev)
              local function lsp_callback(bufnr)
                  -- Enable completion triggered by <c-x><c-o>
                  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                  -- Buffer local mappings.
                  local function opts_desc(desc)
                      return { buffer = bufnr, desc = desc }
                  end
                  local map = vim.keymap.set
                  map("n", "gD", vim.lsp.buf.declaration, opts_desc("Goto declaration"))
                  map("n", "gd", vim.lsp.buf.definition, opts_desc("Goto definition"))
                  map("n", "gI", vim.lsp.buf.implementation, opts_desc("Goto implementation"))
                  map("n", "gr", vim.lsp.buf.references, opts_desc("Goto references"))
                  map("n", "K", vim.lsp.buf.hover, {})
                  map({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, opts_desc("Signature help"))
                  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts_desc("Add workspace folder"))
                  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts_desc("Remove workspace folder"))
                  map("n", "<leader>wl", function()
                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end, opts_desc("Print workspace folders list"))
                  map("n", "<leader>gy", vim.lsp.buf.type_definition, opts_desc("Goto t(y)pe definition"))
                  map("n", "<leader>cr", vim.lsp.buf.rename, opts_desc("Code rename"))
                  map("n", "<leader>ca", vim.lsp.buf.code_action, opts_desc("Code action"))
                  map({ "n", "v" }, "<leader>=", vim.lsp.buf.format, opts_desc("Code format"))
              end
              lsp_callback(ev.buf)
          end
        '';
      };
    }
  ];
}
