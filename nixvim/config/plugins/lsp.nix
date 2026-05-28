{
  plugins = {
    lspconfig.enable = true;
    lspsaga = {
      enable = true;
      settings = {
        lightbulb.virtualText = false;
        symbol_in_winbar.enable = true;
        outline.win_width = 50;
      };
    };
  };
  autoCmd = [
    {
      desc = "Configure LSP keymaps and omnifunc";
      event = "LspAttach";
      callback.__raw = ''
        function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
      '';
    }
  ];
  lsp.keymaps = let
    lspsaga = action: "<cmd>Lspsaga ${action}<cr>";
  in [
    {
      mode = "n";
      key = "gF";
      action = lspsaga "finder";
      options.desc = "Goto symbol finder";
    }
    {
      mode = "n";
      key = "gl";
      action = lspsaga "outline";
      options.desc = "Goto LSP out(l)ine";
    }
    {
      mode = "n";
      key = "gD";
      lspBufAction = "declaration";
      options.desc = "Goto declaration";
    }
    {
      mode = "n";
      key = "gd";
      lspBufAction = "definition";
      options.desc = "Goto definition";
    }
    {
      mode = "n";
      key = "gI";
      lspBufAction = "implementation";
      options.desc = "Goto implementation";
    }
    {
      mode = "n";
      key = "gt";
      lspBufAction = "type_definition";
      options.desc = "Goto type";
    }
    {
      mode = "n";
      key = "gr";
      lspBufAction = "references";
      options.desc = "Goto references";
    }
    {
      mode = "n";
      key = "K";
      action = lspsaga "hover_doc";
    }
    {
      mode = ["i" "n"];
      key = "<C-k>";
      lspBufAction = "signature_help";
      options.desc = "Signature help";
    }
    {
      mode = "n";
      key = "<leader>wa";
      action.__raw = "vim.lsp.buf.add_workspace_folder";
      options.desc = "Add workspace folder";
    }
    {
      mode = "n";
      key = "<leader>wr";
      action.__raw = "vim.lsp.buf.remove_workspace_folder";
      options.desc = "Remove workspace folder";
    }
    {
      mode = "n";
      key = "<leader>wl";
      action.__raw = ''
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end
      '';
      options.desc = "Print workspace folders list";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = lspsaga "peek_definition";
      options.desc = "Peek definition";
    }
    {
      mode = "n";
      key = "<leader>gy";
      action = lspsaga "peek_type_definition";
      options.desc = "Peek t(y)pe definition";
    }
    {
      mode = "n";
      key = "<leader>gY";
      action = lspsaga "goto_type_definition";
      options.desc = "Goto t(y)pe definition";
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = lspsaga "code_action";
      options.desc = "Code action";
    }
    {
      mode = ["n" "v"];
      key = "<leader>=";
      lspBufAction = "format";
      options.desc = "Code format";
    }
    {
      mode = "n";
      key = "<leader>cr";
      lspBufAction = "rename";
      options.desc = "Code rename";
    }
  ];
  keymaps = [
    {
      mode = "n";
      key = "<C-;>";
      action = "<cmd>Lspsaga term_toggle<cr>";
      options.desc = "Toggle floating terminal";
    }
  ];
}
