{pkgs, ...}: {
  # DAP support
  imports = [./dap.nix];
  plugins.dap-python.enable = true;
  inherit (import ./dap.nix) keymaps;

  # LSP config with ty and ruff
  lsp = {
    servers.ty.enable = true;
    servers.ruff.enable = true;
  };

  # conform setup
  plugins.conform-nvim.settings.formatters_by_ft.python = ["isort"];
  extraPackages = with pkgs; [
    isort
    ty
  ];
}
