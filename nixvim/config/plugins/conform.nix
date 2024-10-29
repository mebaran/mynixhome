{
  plugins.conform-nvim.enable = true;
  keymaps = [
    {
      key = "<leader>cf";
      action = ''<cmd>lua require("conform").format({ lsp_fallback = true })<cr>'';
      options.desc = "Format via Conform";
    }
  ];
}
