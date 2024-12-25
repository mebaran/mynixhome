{
  plugins = {
    friendly-snippets.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        trigger.signature_help.enabled = true;
        highlight = {
          use_nvim_cmp_as_default = true;
        };
        list.selection = "auto_insert";
        keymap = {
          preset = "enter";
        };
      };
    };
  };
}
