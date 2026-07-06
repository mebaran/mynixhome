{pkgs, ...}: {
  # Import all your configuration modules here
  imports = [./plugins ./editor.nix ./keymaps.nix ./colorscheme.nix];

  extraPackages = with pkgs; [
    fd
    git
    lazygit
    ripgrep
  ];

  extraConfigLua = ''
    local matugen_path = vim.fn.stdpath("config") .. "/lua/matugen.lua"

    if vim.uv.fs_stat(matugen_path) then
      dofile(matugen_path)
    end
  '';

  performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      pathsToLink = ["/template"];
      standalonePlugins = [
        "friendly-snippets"
        "blink.cmp"
        "snacks.nvim"
      ];
    };
  };

  vimAlias = true;
}
