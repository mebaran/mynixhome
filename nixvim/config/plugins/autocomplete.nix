{
  plugins = {
    friendly-snippets.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        signature.enabled = true;
        appearance.use_nvim_cmp_as_default = true;
        completion.list.selection = "auto_insert";
        keymap.__raw = ''
          {
            preset = 'enter',
            ['<Tab>'] = {
              function(cmp)
                if cmp.snippet_active() then return
                else return cmp.select_next() end
              end,
              'snippet_forward',
              'fallback'
            },
            ['<S-Tab>'] = {
              function(cmp)
                if cmp.snippet_active() then return
                else return cmp.select_prev() end
              end,
              'snippet_backward',
              'fallback'
            },
          }
        ''; 
      };
    };
  };
}
