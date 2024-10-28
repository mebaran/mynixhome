{
  imports = [
    ./gitsigns.nix
    ./lualine.nix
    ./mini.nix
    ./treesitter.nix
    ./trouble.nix
    # ./yanky.nix
  ];
  plugins.nvim-bqf.enable = true;
  plugins.ts-comments.enable = true;
  
}
