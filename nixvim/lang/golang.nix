{pkgs, ...}: {
  lsp.servers.gopls.enable = true;
  extraPackages = with pkgs; [
    gomodifytags
    reftools
  ];
}
