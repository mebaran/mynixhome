{pkgs, ...}: {
  plugins = {
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
      };
    };
    conform-nvim = {
      settings.formatters_by_ft.nix = ["alejandra"];
    };
  };
  extraPackages = with pkgs; [
    alejandra
  ];
  autoCmd = [
    {
      event = "BufEnter";
      pattern = "*.nix";
      callback.__raw = ''
        function()
            vim.api.nvim_buf_set_option(0, 'shiftwidth', 2)
            vim.api.nvim_buf_set_option(0, 'tabstop', 2)
            vim.api.nvim_buf_set_option(0, 'softtabstop', 2)
        end
      '';
    }
  ];
}
