{pkgs, ...}: {
  plugins = {
    lsp.enable = true;
    lsp.servers.basedpyright.enable = true;
    conform-nvim.settings.formatters_by_ft.python = [
      "autopep8"
      "black"
      "isort"
    ];
    dap.extensions.dap-python.enable = true;
  };
  extraPackages = with pkgs.python3Packages; [
    autopep8
    black
    isort
  ];
  inherit (import ./dap.nix) keymaps;
}
