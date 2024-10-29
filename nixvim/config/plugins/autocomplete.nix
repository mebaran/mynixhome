{
    plugins = {
        luasnip.enable = true;
        friendly-snippets.enable = true;
        cmp_luasnip.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp = {
            enable = true;
            luaConfig.pre = builtins.readFile ./lua/cmp.lua; 
        };
    };
}
