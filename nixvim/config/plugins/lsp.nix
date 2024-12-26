{
  plugins.lsp = {
    enable = true;
    capabilities = "require('blink.cmp').get_lsp_capabilities()";
  };
  plugins.lspsaga.enable = true;
  autoCmd = let
    lspsaga = action: ''"<cmd>Lspsaga ${action}<cr>"'';
  in [
    {
      desc = "Configure LSP keymaps and omnifunc";
      event = "LspAttach";
      callback.__raw = ''
        function(ev)
            local function lsp_callback(bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                -- Buffer local mappings.
                local function opts_desc(desc)
                    return { buffer = bufnr, desc = desc }
                end
                local map = vim.keymap.set
                map("n", "gF", ${lspsaga "finder"}, opts_desc("Goto symbol finder"))
                map("n", "gD", vim.lsp.buf.declaration, opts_desc("Goto declaration"))
                map("n", "gd", vim.lsp.buf.definition, opts_desc("Goto definition"))
                map("n", "gI", vim.lsp.buf.implementation, opts_desc("Goto implementation"))
                map("n", "gr", vim.lsp.buf.references, opts_desc("Goto references"))
                map("n", "K", ${lspsaga "hover_doc"}, {})
                map({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, opts_desc("Signature help"))
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts_desc("Add workspace folder"))
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts_desc("Remove workspace folder"))
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts_desc("Print workspace folders list"))
                map("n", "<leader>gd", ${lspsaga "peek_definition"}, opts_desc("Peek definition"))
                map("n", "<leader>gy", ${lspsaga "peek_type_definition"}, opts_desc("Peek t(y)pe definition"))
                map("n", "<leader>cr", vim.lsp.buf.rename, opts_desc("Code rename"))
                map("n", "<leader>ca", ${lspsaga "code_action"}, opts_desc("Code action"))
                map({ "n", "v" }, "<leader>=", vim.lsp.buf.format, opts_desc("Code format"))
            end
            lsp_callback(ev.buf)
        end
      '';
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
