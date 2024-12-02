{pkgs, ...}: {
  plugins = {
    lsp.enable = true;
    lsp.servers = {
      emmet-language-server.enable = true;
      htmx-lsp.enable = true;
    };
    conform-nvim.settings.formatters_by_ft = {
      css = ["prettierd"];
      html = ["pretterd"];
      javascript = ["prettierd"];
    };
  };
  extraPackages = with pkgs; [
    prettierd
  ];
}
