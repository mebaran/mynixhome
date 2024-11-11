{
  plugins.lsp.enable = true;
  autoCmd = [
    {
      description = "LSP configuration autocommand";
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
            print("Configuring LSP keymaps...")
            lsp_callback(ev.buf)
        end
      '';
    }
  ];
}
