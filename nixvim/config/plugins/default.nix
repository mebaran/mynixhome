{
  imports = [
    ./autocomplete.nix
    ./codecompanion.nix
    ./conform.nix
    ./flash.nix
    ./gitsigns.nix
    ./lualine.nix
    ./lsp.nix
    ./mini.nix
    ./treesitter.nix
    ./trouble.nix
    ./yanky.nix
  ];
  plugins = {
    diffview.enable = true;
    lazygit.enable = true;
    nvim-bqf.enable = true;
    render-markdown.enable = true;
    sqlite-lua.enable = true;
    ts-comments.enable = true;
    zen-mode.enable = true;
  };
}
{
  plugins.codecompanion = {
    enable = true;
  };
}
