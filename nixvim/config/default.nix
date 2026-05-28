{pkgs, ...}: {
  # Import all your configuration modules here
  imports = [./plugins ./editor.nix ./keymaps.nix ./colorscheme.nix];

  extraPackages = with pkgs; [
    fd
    git
    lazygit
    ripgrep
  ];

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
