{
  imports = [
    ./mini.nix
    ./lualine.nix
    ./treesitter.nix
    ./gitsigns.nix
    # ./yanky.nix
  ];
  plugins.nvim-bqf.enable = true;
  plugins.ts-comments.enable = true;
}
