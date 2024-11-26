{
  imports = [
    ./autocomplete.nix
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
    nvim-bqf.enable = true;
    sqlite-lua.enable = true;
    ts-comments.enable = true;
    zen-mode.enable = true;
    lazygit.enable = true;
    render-markdown.enable = true;
  };
}
