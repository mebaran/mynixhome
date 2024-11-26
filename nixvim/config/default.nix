{ pkgs, ...}:
{
  # Import all your configuration modules here
  imports = [./editor.nix ./keymaps.nix ./plugins];
  
  colorschemes.poimandres.enable = true;
  
  extraPackages = with pkgs; [
    fd
    fzf
    git
    lazygit
    ripgrep
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-unception
  ];
}
