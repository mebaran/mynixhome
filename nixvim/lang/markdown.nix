{pkgs, ...}: {
  plugins.conform-nvim.settings.formatters_by_ft.markdown = ["mdformat"];
  extraPackages = [
    pkgs.mdformat
  ];
  autoCmd = [
    {
      event = "FileType";
      pattern = "markdown";
      callback.__raw = ''
        function()
            vim.api.nvim_buf_set_option(0, 'textwidth', 100)
            vim.api.nvim_buf_set_option(0, 'wrap', true)
            vim.api.nvim_buf_set_option(0, 'linebreak', true)
        end
      '';
    }
  ];
}
